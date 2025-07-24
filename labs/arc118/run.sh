#!/bin/bash

PS4='\033[1;94m[ Line ${LINENO} ] \033[0m'

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

# --------------------------------
# Set up environment
# --------------------------------
gcloud config set run/region $REGION
gcloud config set run/platform managed
gcloud config set eventarc/location $REGION

grant_service_account_roles $COMPUTE_SERVICE_ACCOUNT "roles/eventarc.admin"

# --------------------------------
# Create a Pub/Sub topic
# --------------------------------
PUBSUB_TOPIC_NAME=$PROJECT_ID-topic
PUBSUB_TOPIC_SUB_NAME=$PROJECT_ID-topic-sub

gcloud pubsub topics create $PUBSUB_TOPIC_NAME
gcloud pubsub subscriptions create $PUBSUB_TOPIC_SUB_NAME --topic $PUBSUB_TOPIC_NAME

# --------------------------------
# Create a Pub/Sub subscription
# --------------------------------
RUN_SERVICE_NAME=pubsub-events
RUN_IMAGE_NAME=gcr.io/cloudrun/hello

gcloud run deploy $RUN_SERVICE_NAME \
  --image $RUN_IMAGE_NAME \
  --allow-unauthenticated \
  --max-instances 3

# --------------------------------
# Create a Pub/Sub event trigger
# --------------------------------
PUBSUB_TRIGGER_NAME=pubsub-events-trigger

gcloud eventarc triggers create $PUBSUB_TRIGGER_NAME \
  --destination-run-service $RUN_SERVICE_NAME \
  --event-filters "type=google.cloud.pubsub.topic.v1.messagePublished" \
  --transport-topic $PUBSUB_TOPIC_NAME && sleep 30

gcloud eventarc triggers list

# --------------------------------
# Trigger the Pub/Sub event
# --------------------------------
PUBSUB_TOPIC_ID=$(gcloud pubsub topics list --filter="name:$PUBSUB_TOPIC_NAME" --format="value(name)")

gcloud pubsub topics publish $PUBSUB_TOPIC_ID --message "Hello, world!" && sleep 30

gcloud logging read 'resource.labels.service_name="'"$RUN_SERVICE_NAME"'"'
