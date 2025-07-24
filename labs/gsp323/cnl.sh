#!/bin/bash

set -eux

# --------------------------------
# Set up environment
# --------------------------------
PROJECT_ID=$(gcloud config get-value project)

# --------------------------------
# Set up service account
# --------------------------------
SA_NAME=cnl-sa
SA_EMAIL=$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com
SA_KEY_FILE=$HOME/key.json

gcloud iam service-accounts delete $SA_EMAIL --quiet && sleep 5
gcloud iam service-accounts create $SA_NAME --display-name "Service Account for Cloud Natural Language API" && sleep 5
gcloud iam service-accounts keys create $SA_KEY_FILE --iam-account $SA_EMAIL && sleep 5

export GOOGLE_CLOUD_PROJECT=$PROJECT_ID
export GOOGLE_APPLICATION_CREDENTIALS=$SA_KEY_FILE

# --------------------------------
# Call Cloud Natural Language API
# --------------------------------
TEXT="Old Norse texts portray Odin as one-eyed and long-bearded, frequently wielding a spear named Gungnir and wearing a cloak and a broad hat."

gcloud ml language analyze-entities --content="$TEXT" > cnl_result.json

gsutil cp cnl_result.json gs://${PROJECT_ID}-marking/task4-cnl-954.result
