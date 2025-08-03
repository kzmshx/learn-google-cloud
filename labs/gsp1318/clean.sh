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

# Resource names from run.sh
ROUTING_VPC_NETWORK_NAME=routing-vpc
ROUTING_VPC_ROUTER_NAME=routing-vpc-cr
ROUTING_VPC_GATEWAY_NAME=routing-vpc-vpn-gateway
ROUTING_VPC_TUNNEL_NAME=routing-vpc-tunnel

ON_PREM_VPC_NETWORK_NAME=on-prem-net-vpc
ON_PREM_VPC_ROUTER_NAME=on-prem-router
ON_PREM_VPC_GATEWAY_NAME=on-prem-vpn-gateway
ON_PREM_TUNNEL_NAME=on-prem-tunnel

NCC_HUB_NAME=mesh-hub
VPC_SPOKE_NAME=workload-vpc-spoke
VPN_SPOKE_NAME=hybrid-spoke

INTERFACE_HUB_NAME=if-hub-to-prem
BGP_HUB_NAME=bgp-hub-to-prem
INTERFACE_PREM_NAME=if-prem-to-hub
BGP_PREM_NAME=bgp-prem-to-hub

# --------------------------------
# Delete NCC Spokes
# --------------------------------
echo "Deleting NCC spokes..."
gcloud network-connectivity spokes delete $VPC_SPOKE_NAME --global --quiet || true
gcloud network-connectivity spokes delete $VPN_SPOKE_NAME --region $REGION --quiet || true

# Wait for spokes to be deleted
echo "Waiting for spokes deletion to complete..."
sleep 30

# --------------------------------
# Delete NCC Hub
# --------------------------------
echo "Deleting NCC hub..."
gcloud network-connectivity hubs delete $NCC_HUB_NAME --quiet || true

# --------------------------------
# Delete BGP sessions and interfaces
# --------------------------------
echo "Deleting BGP sessions and interfaces..."
gcloud compute routers remove-bgp-peer $ROUTING_VPC_ROUTER_NAME \
  --peer-name $BGP_HUB_NAME \
  --region $REGION \
  --quiet || true

gcloud compute routers remove-interface $ROUTING_VPC_ROUTER_NAME \
  --interface-name $INTERFACE_HUB_NAME \
  --region $REGION \
  --quiet || true

gcloud compute routers remove-bgp-peer $ON_PREM_VPC_ROUTER_NAME \
  --peer-name $BGP_PREM_NAME \
  --region $REGION \
  --quiet || true

gcloud compute routers remove-interface $ON_PREM_VPC_ROUTER_NAME \
  --interface-name $INTERFACE_PREM_NAME \
  --region $REGION \
  --quiet || true

# --------------------------------
# Delete VPN tunnels
# --------------------------------
echo "Deleting VPN tunnels..."
gcloud compute vpn-tunnels delete $ROUTING_VPC_TUNNEL_NAME \
  --region $REGION \
  --quiet || true

gcloud compute vpn-tunnels delete $ON_PREM_TUNNEL_NAME \
  --region $REGION \
  --quiet || true

# --------------------------------
# Delete VPN gateways
# --------------------------------
echo "Deleting VPN gateways..."
gcloud compute vpn-gateways delete $ROUTING_VPC_GATEWAY_NAME \
  --region $REGION \
  --quiet || true

gcloud compute vpn-gateways delete $ON_PREM_VPC_GATEWAY_NAME \
  --region $REGION \
  --quiet || true

# --------------------------------
# Delete routers
# --------------------------------
echo "Deleting routers..."
gcloud compute routers delete $ROUTING_VPC_ROUTER_NAME \
  --region $REGION \
  --quiet || true

gcloud compute routers delete $ON_PREM_VPC_ROUTER_NAME \
  --region $REGION \
  --quiet || true

echo "Cleanup completed successfully!"