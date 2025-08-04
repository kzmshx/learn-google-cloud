#!/bin/bash

PS4='\033[1;94m[ Line ${LINENO} ] \033[0m'

set -eux

# --------------------------------
# Parse args
# --------------------------------
while [[ $# -gt 0 ]]; do
  case $1 in
  --region) REGION="$2" && shift 2 ;;
  --zone) ZONE="$2" && shift 2 ;;
  --* | -*) echo "unknown option: $1" >&2 && exit 1 ;;
  *) break ;;
  esac
done

echo "region: $REGION"
echo "zone: $ZONE"

# --------------------------------
# Constants
# --------------------------------
PROJECT_ID=$(gcloud config get-value project)
PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')
COMPUTE_SERVICE_ACCOUNT=${PROJECT_NUMBER}-compute@developer.gserviceaccount.com

# --------------------------------
# Functions
# --------------------------------
function enable_apis() {
  local APIS=("${@:1}")
  for API in "${APIS[@]}"; do
    gcloud services enable $API
  done
}

function grant_service_account_roles() {
  local SERVICE_ACCOUNT=$1
  local ROLES=("${@:2}")
  for ROLE in "${ROLES[@]}"; do
    gcloud projects add-iam-policy-binding $PROJECT_ID --member "serviceAccount:$SERVICE_ACCOUNT" --role "$ROLE"
  done
}

# --------------------------------
# Enable the Network Connectivity API
# --------------------------------
enable_apis networkconnectivity.googleapis.com

# --------------------------------
# Create a NCC hub
# --------------------------------
HUB_NAME=gsp0528-hub

gcloud network-connectivity hubs create $HUB_NAME

# --------------------------------
# Create On-Prem VPN spokes
# --------------------------------
OFFICE_1_TUNNEL_1_NAME=onprem-office1-to-routing-tunnel-0
OFFICE_1_TUNNEL_2_NAME=onprem-office1-to-routing-tunnel-1
OFFICE_2_TUNNEL_1_NAME=onprem-office2-to-routing-tunnel-0
OFFICE_2_TUNNEL_2_NAME=onprem-office2-to-routing-tunnel-1

OFFICE_1_SPOKE_NAME=gsp0528-spoke-office-1
OFFICE_2_SPOKE_NAME=gsp0528-spoke-office-2

gcloud network-connectivity spokes linked-vpn-tunnels create $OFFICE_1_SPOKE_NAME \
  --hub $HUB_NAME \
  --vpn-tunnels $OFFICE_1_TUNNEL_1_NAME,$OFFICE_1_TUNNEL_2_NAME \
  --region $REGION

gcloud network-connectivity spokes linked-vpn-tunnels create $OFFICE_2_SPOKE_NAME \
  --hub $HUB_NAME \
  --vpn-tunnels $OFFICE_2_TUNNEL_1_NAME,$OFFICE_2_TUNNEL_2_NAME \
  --region $REGION

# verify connectivity
OFFICE_1_VM_NAME=onprem-office1-vm
OFFICE_2_VM_NAME=onprem-office2-vm

OFFICE_1_VM_IP=$(gcloud compute instances describe $OFFICE_1_VM_NAME --zone $ZONE --format "value(networkInterfaces[0].networkIP)")
OFFICE_2_VM_IP=$(gcloud compute instances describe $OFFICE_2_VM_NAME --zone $ZONE --format "value(networkInterfaces[0].networkIP)")

gcloud compute ssh $OFFICE_1_VM_NAME --zone $ZONE --command "ping -c 5 $OFFICE_2_VM_IP"
gcloud compute ssh $OFFICE_2_VM_NAME --zone $ZONE --command "ping -c 5 $OFFICE_1_VM_IP"

# --------------------------------
# Create VPC spokes
# --------------------------------
WORKLOAD_1_VPC_NAME=workload-vpc-1
WORKLOAD_2_VPC_NAME=workload-vpc-2

WORKLOAD_1_SPOKE_NAME=gsp0528-spoke-workload-1
WORKLOAD_2_SPOKE_NAME=gsp0528-spoke-workload-2

gcloud network-connectivity spokes linked-vpc-network create $WORKLOAD_1_SPOKE_NAME \
  --hub $HUB_NAME \
  --vpc-network $WORKLOAD_1_VPC_NAME \
  --global

gcloud network-connectivity spokes linked-vpc-network create $WORKLOAD_2_SPOKE_NAME \
  --hub $HUB_NAME \
  --vpc-network $WORKLOAD_2_VPC_NAME \
  --global

# verify connectivity
WORKLOAD_1_VM_NAME=workload1-vm
WORKLOAD_2_VM_NAME=workload2-vm

WORKLOAD_1_VM_IP=$(gcloud compute instances describe $WORKLOAD_1_VM_NAME --zone $ZONE --format "value(networkInterfaces[0].networkIP)")
WORKLOAD_2_VM_IP=$(gcloud compute instances describe $WORKLOAD_2_VM_NAME --zone $ZONE --format "value(networkInterfaces[0].networkIP)")

gcloud compute ssh $WORKLOAD_1_VM_NAME --zone $ZONE --command "ping -c 5 $WORKLOAD_2_VM_IP"
gcloud compute ssh $WORKLOAD_2_VM_NAME --zone $ZONE --command "ping -c 5 $WORKLOAD_1_VM_IP"

# --------------------------------
# Create a hybrid spoke
# --------------------------------
ROUTING_VPC_TUNNEL_1_NAME=routing-to-onprem-office1-tunnel-0
ROUTING_VPC_TUNNEL_2_NAME=routing-to-onprem-office1-tunnel-1

HYBRID_SPOKE_NAME=gsp0528-spoke-hybrid

gcloud network-connectivity spokes linked-vpn-tunnels create $HYBRID_SPOKE_NAME \
  --hub $HUB_NAME \
  --vpn-tunnels $ROUTING_VPC_TUNNEL_1_NAME,$ROUTING_VPC_TUNNEL_2_NAME \
  --region $REGION

# verify connectivity
gcloud compute ssh $WORKLOAD_1_VM_NAME --zone $ZONE --command "ping -c 5 $OFFICE_1_VM_IP"
gcloud compute ssh $OFFICE_1_VM_NAME --zone $ZONE --command "ping -c 5 $WORKLOAD_1_VM_IP"
