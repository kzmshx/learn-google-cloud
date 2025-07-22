#!/bin/bash

set -eux

# --------------------------------
# Parse args
# --------------------------------
while [[ $# -gt 0 ]]; do
  case $1 in
  --region)
    REGION="$2"
    shift 2
    ;;
  --* | -*) echo "Unknown option: $1" >&2 && exit 1 ;;
  *) break ;;
  esac
done

# --------------------------------
# Set up environment
# --------------------------------
PROJECT_ID=$(gcloud config get-value project)
PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')

gcloud config set project $PROJECT_ID
