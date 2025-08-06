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
