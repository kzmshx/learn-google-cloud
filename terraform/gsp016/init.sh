#!/bin/bash
set -e

PROJECT_ID=$1
if [ -z "$PROJECT_ID" ]; then
  echo "./init.sh <project_id>"
  exit 1
fi

gcloud auth application-default login
gcloud config set project $PROJECT_ID

terraform init
