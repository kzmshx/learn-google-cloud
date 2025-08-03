#!/bin/bash

set -eux

# --------------------------------
# Set up environment
# --------------------------------
PROJECT_ID=$(gcloud config get-value project)

# --------------------------------
# Call Cloud Natural Language API
# --------------------------------
API_KEY=$(gcloud alpha services api-keys create --display-name "Speech-to-Text API Key" --format "value(response.keyString)")

cat >request.json <<EOF
{
  "config": {
      "encoding":"FLAC",
      "languageCode": "en-US"
  },
  "audio": {
      "uri":"gs://cloud-training/gsp323/task3.flac"
  }
}
EOF

curl -s "https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" \
  -X POST \
  -H "Content-Type: application/json" \
  --data-binary @request.json \
  >stt_result.json

gsutil cp stt_result.json gs://${PROJECT_ID}-marking/task3-gcs-181.result
