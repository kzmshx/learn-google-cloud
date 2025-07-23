#!/bin/bash

set -eux

# --------------------------------
# Parse args
# --------------------------------
while [[ $# -gt 0 ]]; do
  case $1 in
  --* | -*) echo "unknown option: $1" >&2 && exit 1 ;;
  *) break ;;
  esac
done

# --------------------------------
# Set up environment
# --------------------------------
PROJECT_ID=$(gcloud config get-value project)
PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')

# --------------------------------
# Create a service account
# --------------------------------
SA_NAME=quickstart
SA_EMAIL=$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com
SA_KEY_FILE=~/key.json

gcloud iam service-accounts create $SA_NAME && sleep 1
gcloud iam service-accounts keys create $SA_KEY_FILE --iam-account $SA_EMAIL && sleep 1
gcloud auth activate-service-account --key-file $SA_KEY_FILE && sleep 1

TOKEN=$(gcloud auth print-access-token)

# --------------------------------
# Call Video Intelligence API
# --------------------------------

cat >request.json <<EOF
{
  "inputUri": "gs://spls/gsp154/video/train.mp4",
  "features": ["LABEL_DETECTION"]
}
EOF

curl -s "https://videointelligence.googleapis.com/v1/videos:annotate" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d @request.json \
  >response_submit.json

OPERATION_ID=$(jq -r '.name' response_submit.json)
echo "Operation submitted: $OPERATION_ID"

while true; do
  echo "Checking operation status..."
  curl -s "https://videointelligence.googleapis.com/v1/$OPERATION_ID" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    >response_result.json

  STATUS=$(jq -r '.done' response_result.json)
  if [ "$STATUS" = "true" ]; then
    echo "Operation completed"
    cat response_result.json
    break
  fi

  sleep 5
done
