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
# Check existing VPCs
# --------------------------------
gcloud compute networks list

# --------------------------------
# Set up HA VPC
# --------------------------------
ROUTING_VPC_NETWORK_NAME=routing-vpc
ROUTING_VPC_ROUTER_NAME=routing-vpc-cr
ROUTING_VPC_ROUTER_ASN=64525
ROUTING_VPC_GATEWAY_NAME=routing-vpc-vpn-gateway

# configure BGP for Routing VPC
gcloud compute routers create $ROUTING_VPC_ROUTER_NAME \
  --region $REGION \
  --network $ROUTING_VPC_NETWORK_NAME \
  --asn $ROUTING_VPC_ROUTER_ASN
# configure VPC Gateway for Routing VPC
gcloud compute vpn-gateways create $ROUTING_VPC_GATEWAY_NAME \
  --region $REGION \
  --network $ROUTING_VPC_NETWORK_NAME

ON_PREM_VPC_NETWORK_NAME=on-prem-net-vpc
ON_PREM_VPC_ROUTER_NAME=on-prem-router
ON_PREM_VPC_ROUTER_ASN=64526
ON_PREM_VPC_GATEWAY_NAME=on-prem-vpn-gateway

# configure BGP for ON-Prem VPC
gcloud compute routers create $ON_PREM_VPC_ROUTER_NAME \
  --region $REGION \
  --network $ON_PREM_VPC_NETWORK_NAME \
  --asn $ON_PREM_VPC_ROUTER_ASN
# configure VPC Gateway for ON-Prem VPC
gcloud compute vpn-gateways create $ON_PREM_VPC_GATEWAY_NAME \
  --region $REGION \
  --network $ON_PREM_VPC_NETWORK_NAME

# configure VPN tunnels
SECRET_KEY=$(openssl rand -base64 24)
ROUTING_VPC_TUNNEL_NAME=routing-vpc-tunnel
ON_PREM_TUNNEL_NAME=on-prem-tunnel

gcloud compute vpn-tunnels create $ROUTING_VPC_TUNNEL_NAME \
  --vpn-gateway $ROUTING_VPC_GATEWAY_NAME \
  --peer-gcp-gateway $ON_PREM_VPC_GATEWAY_NAME \
  --router $ROUTING_VPC_ROUTER_NAME \
  --region $REGION \
  --interface 0 \
  --shared-secret $SECRET_KEY
gcloud compute vpn-tunnels create $ON_PREM_TUNNEL_NAME \
  --vpn-gateway $ON_PREM_VPC_GATEWAY_NAME \
  --peer-gcp-gateway $ROUTING_VPC_GATEWAY_NAME \
  --router $ON_PREM_VPC_ROUTER_NAME \
  --region $REGION \
  --interface 0 \
  --shared-secret $SECRET_KEY

# create BGP sessions
INTERFACE_HUB_NAME=if-hub-to-prem
HUB_ROUTER_IP=169.254.1.1

gcloud compute routers add-interface $ROUTING_VPC_ROUTER_NAME \
  --interface-name $INTERFACE_HUB_NAME \
  --ip-address $HUB_ROUTER_IP \
  --mask-length 30 \
  --vpn-tunnel $ROUTING_VPC_TUNNEL_NAME \
  --region $REGION

BGP_HUB_NAME=bgp-hub-to-prem
PREM_ROUTER_IP=169.254.1.2

gcloud compute routers add-bgp-peer $ROUTING_VPC_ROUTER_NAME \
  --peer-name $BGP_HUB_NAME \
  --peer-ip-address $PREM_ROUTER_IP \
  --peer-asn $ON_PREM_VPC_ROUTER_ASN \
  --interface $INTERFACE_HUB_NAME \
  --region $REGION

INTERFACE_PREM_NAME=if-prem-to-hub

gcloud compute routers add-interface $ON_PREM_VPC_ROUTER_NAME \
  --interface-name $INTERFACE_PREM_NAME \
  --ip-address $PREM_ROUTER_IP \
  --mask-length 30 \
  --vpn-tunnel $ON_PREM_TUNNEL_NAME \
  --region $REGION

BGP_PREM_NAME=bgp-prem-to-hub

gcloud compute routers add-bgp-peer $ON_PREM_VPC_ROUTER_NAME \
  --peer-name $BGP_PREM_NAME \
  --peer-ip-address $HUB_ROUTER_IP \
  --peer-asn $ROUTING_VPC_ROUTER_ASN \
  --interface $INTERFACE_PREM_NAME \
  --region $REGION

# advertise VPC spoke subnets to On-Prem router
VPC_SPOKE_SUBNET_IP_RANGE=10.0.1.0/24

gcloud compute routers update $ROUTING_VPC_ROUTER_NAME \
  --advertisement-mode custom \
  --set-advertisement-groups all_subnets \
  --set-advertisement-ranges $VPC_SPOKE_SUBNET_IP_RANGE \
  --region $REGION

# advertise On-Prem subnets to Routing VPC router
gcloud compute routers update $ON_PREM_VPC_ROUTER_NAME \
  --advertisement-mode custom \
  --set-advertisement-groups all_subnets \
  --region $REGION

# update BGP peer for On-Prem router
gcloud compute routers update-bgp-peer $ON_PREM_VPC_ROUTER_NAME \
  --peer-name $BGP_PREM_NAME \
  --advertised-route-priority "111" \
  --region $REGION

# check VPN tunnel status
gcloud compute vpn-tunnels describe $ROUTING_VPC_TUNNEL_NAME \
  --region $REGION \
  --format 'flattened(status,detailedStatus)'

gcloud compute routers get-status $ROUTING_VPC_ROUTER_NAME \
  --region $REGION

# --------------------------------
# Set up NCC hub
# --------------------------------
NCC_HUB_NAME=mesh-hub

gcloud network-connectivity hubs create $NCC_HUB_NAME
sleep 20

gcloud network-connectivity hubs describe $NCC_HUB_NAME
gcloud network-connectivity hubs route-tables list --hub $NCC_HUB_NAME
gcloud network-connectivity hubs route-tables describe default --hub $NCC_HUB_NAME
gcloud network-connectivity hubs route-tables routes list --hub $NCC_HUB_NAME --route_table default
sleep 20

# --------------------------------
# Set up NCC with Hybrid and VPC Spokes
# --------------------------------
VPC_SPOKE_NAME=workload-vpc-spoke
VPC_SPOKE_NETWORK_NAME=workload-vpc

gcloud network-connectivity spokes linked-vpc-network create $VPC_SPOKE_NAME \
  --hub $NCC_HUB_NAME \
  --vpc-network $VPC_SPOKE_NETWORK_NAME \
  --global

VPN_SPOKE_NAME=hybrid-spoke

gcloud network-connectivity spokes linked-vpn-tunnels create $VPN_SPOKE_NAME \
  --hub $NCC_HUB_NAME \
  --vpn-tunnels $ROUTING_VPC_TUNNEL_NAME \
  --region $REGION

# check spokes
gcloud network-connectivity hubs list-spokes $NCC_HUB_NAME

# check route tables
gcloud network-connectivity hubs route-tables routes list --hub $NCC_HUB_NAME --route_table default
gcloud network-connectivity hubs route-tables routes list --hub $NCC_HUB_NAME --route_table default --effective-location $REGION --filter 10.0.3.0/24

# --------------------------------
# Verify connectivity
# --------------------------------
INSTANCE_NAME=vm3-onprem

gcloud compute instances list --filter 'name=vm3-onprem'

gcloud compute ssh $INSTANCE_NAME --zone $ZONE --command "curl 10.0.1.2 -v"
