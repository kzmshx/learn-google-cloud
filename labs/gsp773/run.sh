#!/bin/bash

PS4='\033[1;94m[[Line ${LINENO}]] \033[0m'

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
# Set up environment
# --------------------------------
PROJECT_ID=$(gcloud config get-value project)
PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')

# set defaults
gcloud config set run/region $REGION
gcloud config set run/platform managed
gcloud config set eventarc/location $REGION

# grant eventarc.admin role to compute service account
COMPUTE_SERVICE_ACCOUNT=${PROJECT_NUMBER}-compute@developer.gserviceaccount.com

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member "serviceAccount:$COMPUTE_SERVICE_ACCOUNT" \
  --role "roles/eventarc.admin"

# --------------------------------
# Explore registered sources and event types
# --------------------------------
gcloud eventarc providers list
gcloud eventarc providers describe pubsub.googleapis.com

# --------------------------------
# Create a Cloud Run sink
# --------------------------------
SERVICE_NAME=event-display
IMAGE_NAME=gcr.io/cloudrun/hello

gcloud run deploy $SERVICE_NAME \
  --image $IMAGE_NAME \
  --allow-unauthenticated \
  --max-instances 3

# --------------------------------
# Create a Pub/Sub event trigger
# --------------------------------
PUBSUB_TRIGGER_NAME=trigger-pubsub

# filter messages published to the topic to cloud run service
gcloud eventarc triggers create $PUBSUB_TRIGGER_NAME \
  --destination-run-service $SERVICE_NAME \
  --event-filters "type=google.cloud.pubsub.topic.v1.messagePublished" && sleep 30

gcloud eventarc triggers list

# test: publish a message to the Pub/Sub topic
TOPIC_ID=$(gcloud eventarc triggers describe $PUBSUB_TRIGGER_NAME --format 'value(transport.pubsub.topic)')
gcloud pubsub topics publish $TOPIC_ID --message "Hello there" && sleep 20
gcloud logging read 'resource.labels.service_name="'"$SERVICE_NAME"'"'

# delete the trigger
gcloud eventarc triggers delete $PUBSUB_TRIGGER_NAME

# --------------------------------
# Create a Audit Logs event trigger
# --------------------------------
# create a bucket
BUCKET_NAME=$PROJECT_ID-cr-bucket
gsutil mb -p $PROJECT_ID -l $REGION gs://$BUCKET_NAME

# enable audit logs for Cloud Storage
gcloud projects get-iam-policy $PROJECT_ID --format json |
  jq '.auditConfigs += [{
      "service": "storage.googleapis.com",
      "auditLogConfigs": [
        { "logType": "ADMIN_READ" },
        { "logType": "DATA_READ" },
        { "logType": "DATA_WRITE" }
      ]
    }]' |
  gcloud projects set-iam-policy $PROJECT_ID /dev/stdin

# test audit logs
echo "Hello World" >random.txt
gsutil cp random.txt gs://$BUCKET_NAME/random.txt && sleep 30
gcloud logging read 'protoPayload.serviceName="storage.googleapis.com"'

# create a trigger
AUDIT_TRIGGER_NAME=trigger-auditlog

gcloud eventarc providers describe cloudaudit.googleapis.com

gcloud eventarc triggers create $AUDIT_TRIGGER_NAME \
  --destination-run-service $SERVICE_NAME \
  --event-filters "type=google.cloud.audit.log.v1.written" \
  --event-filters "serviceName=storage.googleapis.com" \
  --event-filters "methodName=storage.objects.create" \
  --service-account $COMPUTE_SERVICE_ACCOUNT && sleep 30

gcloud eventarc triggers list

# test: create a new bucket object
gsutil cp random.txt gs://$BUCKET_NAME/random.txt && sleep 30
gcloud logging read 'resource.labels.service_name="'"$SERVICE_NAME"'"'

# delete the trigger
gcloud eventarc triggers delete $AUDIT_TRIGGER_NAME
