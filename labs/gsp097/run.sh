#!/bin/bash

set -eux

# --------------------------------
# Parse args
# --------------------------------
while [[ $# -gt 0 ]]; do
  case $1 in
  --region) REGION="$2" && shift 2 ;;
  --zone) ZONE="$2" && shift 2 ;;
  --instance-name) INSTANCE_NAME="$2" && shift 2 ;;
  --* | -*) echo "Unknown option: $1" >&2 && exit 1 ;;
  *) break ;;
  esac
done

echo "REGION: $REGION"
echo "ZONE: $ZONE"
echo "INSTANCE_NAME: $INSTANCE_NAME"

# --------------------------------
# Set up environment
# --------------------------------
PROJECT_ID=$(gcloud config get-value project)
PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')

gcloud config set project $PROJECT_ID

# --------------------------------
# Create service account
# --------------------------------
SA_NAME=my-natlang-sa
SA_EMAIL=$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com
SA_KEY_FILE=~/key.json

gcloud iam service-accounts create $SA_NAME --display-name "my natural language service account"
gcloud iam service-accounts keys create $SA_KEY_FILE --iam-account $SA_EMAIL

export GOOGLE_CLOUD_PROJECT=$PROJECT_ID
export GOOGLE_APPLICATION_CREDENTIALS=$SA_KEY_FILE

# --------------------------------
# Create Cloud Storage bucket
# --------------------------------
gcloud compute ssh $INSTANCE_NAME \
  --zone=$ZONE \
  --command="bash -s" <<EOF
echo "Call Natural Language API for entity analysis"
gcloud ml language analyze-entities --content="Michelangelo Caravaggio, Italian painter, is known for 'The Calling of Saint Matthew'." > result.json

cat result.json
EOF
