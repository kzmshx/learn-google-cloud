#!/bin/bash

set -eux

# --------------------------------
# Parse args
# --------------------------------
while [[ $# -gt 0 ]]; do
  case $1 in
  --zone) ZONE="$2" && shift 2 ;;
  --instance) INSTANCE_NAME="$2" && shift 2 ;;
  --* | -*) echo "Unknown option: $1" >&2 && exit 1 ;;
  *) break ;;
  esac
done

echo "zone: $ZONE"
echo "instance: $INSTANCE_NAME"

# --------------------------------
# Set up environment
# --------------------------------
PROJECT_ID=$(gcloud config get-value project)
PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format 'value(projectNumber)')

gcloud config set project $PROJECT_ID

# --------------------------------
# Get Speech-to-Text API Key
# --------------------------------
API_KEY=$(gcloud alpha services api-keys create --display-name "Speech-to-Text API Key" --format "value(response.keyString)")

# --------------------------------
# Call Speech-to-Text API from Compute Engine VM
# --------------------------------
yes | gcloud compute ssh $INSTANCE_NAME --zone $ZONE --dry-run

gcloud compute ssh $INSTANCE_NAME --zone $ZONE --command "bash -s" <<EOF
  echo '{ "config": { "encoding": "FLAC", "languageCode": "en-US" }, "audio": { "uri": "gs://cloud-samples-tests/speech/brooklyn.flac" } }' > request.json
  curl -s -X POST -H "Content-Type: application/json" --data-binary @request.json "https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" > response.json
  cat response.json
EOF
