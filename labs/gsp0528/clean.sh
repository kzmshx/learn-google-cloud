#!/bin/bash

PS4='\033[1;91m[ Line ${LINENO} ] \033[0m'

set -eux

# --------------------------------
# Parse args
# --------------------------------
while [[ $# -gt 0 ]]; do
  case $1 in
  --region) REGION="$2" && shift 2 ;;
  --* | -*) echo "unknown option: $1" >&2 && exit 1 ;;
  *) break ;;
  esac
done

echo "region: $REGION"

# --------------------------------
# Constants
# --------------------------------
PROJECT_ID=$(gcloud config get-value project)

# --------------------------------
# Delete spokes
# --------------------------------
HYBRID_SPOKE_NAME=gsp0528-spoke-hybrid
gcloud network-connectivity spokes delete $HYBRID_SPOKE_NAME --region $REGION --quiet || echo "Hybrid spoke not found"

WORKLOAD_1_SPOKE_NAME=gsp0528-spoke-workload-1
WORKLOAD_2_SPOKE_NAME=gsp0528-spoke-workload-2
gcloud network-connectivity spokes delete $WORKLOAD_1_SPOKE_NAME --global --quiet || echo "Workload 1 spoke not found"
gcloud network-connectivity spokes delete $WORKLOAD_2_SPOKE_NAME --global --quiet || echo "Workload 2 spoke not found"

OFFICE_1_SPOKE_NAME=gsp0528-spoke-office-1
OFFICE_2_SPOKE_NAME=gsp0528-spoke-office-2
gcloud network-connectivity spokes delete $OFFICE_1_SPOKE_NAME --region $REGION --quiet || echo "Office 1 spoke not found"
gcloud network-connectivity spokes delete $OFFICE_2_SPOKE_NAME --region $REGION --quiet || echo "Office 2 spoke not found"

sleep 30

HUB_NAME=gsp0528-hub
gcloud network-connectivity hubs delete $HUB_NAME --quiet || echo "Hub not found"
