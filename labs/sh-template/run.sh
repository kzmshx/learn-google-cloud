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
function grant_service_account_roles() {
  local SERVICE_ACCOUNT=$1
  local ROLES=("${@:2}")
  for ROLE in "${ROLES[@]}"; do
    gcloud projects add-iam-policy-binding $PROJECT_ID --member "serviceAccount:$SERVICE_ACCOUNT" --role "$ROLE"
  done
}
