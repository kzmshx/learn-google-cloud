#!/bin/bash

PS4='\033[1;94m[ Line ${LINENO} ] \033[0m'
set -eux

# --------------------------------
# Constants
# --------------------------------
PROJECT_ID=$(gcloud config get-value project)

# --------------------------------
# Args
# --------------------------------
# while [[ $# -gt 0 ]]; do
#   case $1 in
#   --* | -*) echo "unknown option: $1" >&2 && exit 1 ;;
#   *) break ;;
#   esac
# done

# --------------------------------
# Utilities
# --------------------------------
# function enable_apis() {
#   local APIS=("${@:1}")
#   for API in "${APIS[@]}"; do gcloud services enable --project $PROJECT_ID $API; done
# }

# function grant_service_account_roles() {
#   local SERVICE_ACCOUNT=$1
#   local ROLES=("${@:2}")
#   for ROLE in "${ROLES[@]}"; do gcloud projects add-iam-policy-binding $PROJECT_ID --member "serviceAccount:$SERVICE_ACCOUNT" --role "$ROLE"; done
# }

# --------------------------------
# Create a VPC
# --------------------------------
gcloud compute networks create mynetwork --subnet-mode auto

gcloud compute networks create privatenet --subnet-mode custom
gcloud compute networks subnets create privatesubnet \
  --network privatenet \
  --region us-east1 \
  --range 10.0.0.0/24 \
  --enable-private-ip-google-access

gcloud compute instances create default-vm-1 --machine-type e2-micro --zone us-east1-d --network default
gcloud compute instances create mynet-vm-1 --machine-type e2-micro --zone us-east1-d --network mynetwork
gcloud compute instances create mynet-vm-2 --machine-type e2-micro --zone us-central1-f --network mynetwork
gcloud compute instances create privatenet-bastion --machine-type e2-micro --zone us-east1-d --subnet privatesubnet --can-ip-forward
gcloud compute instances create privatenet-vm-1 --machine-type e2-micro --zone us-east1-c --subnet privatesubnet

# remove unnecessary resources
gcloud compute instances delete default-vm-1 --zone us-east1-d
gcloud compute networks delete default

# get IP address of Cloud Shell
CLOUD_SHELL_IP=$(curl -s https://api.ipify.org)
echo $CLOUD_SHELL_IP

# create a firewall rule to allow SSH from Cloud Shell
gcloud compute firewall-rules create mynetwork-ingress-allow-ssh-from-cs \
  --network mynetwork \
  --action ALLOW \
  --direction INGRESS \
  --rules tcp:22 \
  --source-ranges $CLOUD_SHELL_IP \
  --target-tags lab-ssh
# add the firewall to VMs via tags
gcloud compute instances add-tags mynet-vm-1 --zone us-east1-d --tags lab-ssh
gcloud compute instances add-tags mynet-vm-2 --zone us-central1-f --tags lab-ssh
# check connectivity
gcloud compute ssh qwiklabs@mynet-vm-1 --zone us-east1-d --command "echo 'Hello from mynet-vm-1'" | true
gcloud compute ssh qwiklabs@mynet-vm-2 --zone us-central1-f --command "echo 'Hello from mynet-vm-2'" | true

# create a firewall rule to allow ICMP for all VMs in mynetwork
gcloud compute firewall-rules create mynetwork-allow-icmp-internal \
  --network mynetwork \
  --action ALLOW \
  --direction INGRESS \
  --rules icmp \
  --source-ranges 10.128.0.0/9
# check connectivity
gcloud compute ssh qwiklabs@mynet-vm-1 --zone us-east1-d --command "ping -c 5 mynet-vm-2.us-central1-f.c.$PROJECT_ID.internal"
echo "This should succeed because ICMP is allowed for all VMs in mynetwork"

# create a firewall rule to deny ICMP with higher priority
gcloud compute firewall-rules create mynetwork-ingress-deny-icmp-all \
  --network mynetwork \
  --action DENY \
  --direction INGRESS \
  --rules icmp \
  --priority 500
# check connectivity
gcloud compute ssh qwiklabs@mynet-vm-1 --zone us-east1-d --command "ping -c 5 mynet-vm-2.us-central1-f.c.$PROJECT_ID.internal" | true
echo "This should fail because the priority of the deny rule is higher than the allow rule"

# update the firewall rule priority
gcloud compute firewall-rules update mynetwork-ingress-deny-icmp-all \
  --priority 2000
# check connectivity
gcloud compute ssh qwiklabs@mynet-vm-1 --zone us-east1-d --command "ping -c 5 mynet-vm-2.us-central1-f.c.$PROJECT_ID.internal"
echo "This should succeed because the priority of the deny rule is now lower than the allow rule"

# create a firewall rule to deny egress ICMP with low priority
gcloud compute firewall-rules create mynetwork-egress-deny-icmp-all \
  --network mynetwork \
  --action DENY \
  --direction EGRESS \
  --rules icmp \
  --priority 10000
# check connectivity
gcloud compute ssh qwiklabs@mynet-vm-1 --zone us-east1-d --command "ping -c 5 mynet-vm-2.us-central1-f.c.$PROJECT_ID.internal" | true
echo "This should fail because traffic is allowed only when both ingress and egress rules allow it"
