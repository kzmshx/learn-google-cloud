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
  --dataproc-cluster-name)
    DATAPROC_CLUSTER_NAME="$2"
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
gcloud config set dataproc/region $REGION

# --------------------------------
# Create a Dataproc cluster
# --------------------------------
SERVICE_ACCOUNT_EMAIL=$PROJECT_NUMBER-compute@developer.gserviceaccount.com
SERVICE_ACCOUNT_ROLE=roles/storage.admin

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member serviceAccount:$SERVICE_ACCOUNT_EMAIL \
  --role $SERVICE_ACCOUNT_ROLE

gcloud compute networks subnets update default \
  --region $REGION \
  --enable-private-ip-google-access

gcloud dataproc clusters create $DATAPROC_CLUSTER_NAME \
  --master-machine-type e2-standard-4 \
  --worker-machine-type e2-standard-4 \
  --worker-boot-disk-size 500

# --------------------------------
# Submit a Spark job
# --------------------------------
gcloud dataproc jobs submit spark \
  --cluster $DATAPROC_CLUSTER_NAME \
  --region $REGION \
  --class org.apache.spark.examples.SparkPi \
  --jars file:///usr/lib/spark/examples/jars/spark-examples.jar \
  -- 1000

# --------------------------------
# Update the Dataproc cluster
# --------------------------------
gcloud dataproc clusters update $DATAPROC_CLUSTER_NAME --num-workers 4
gcloud dataproc clusters update $DATAPROC_CLUSTER_NAME --num-workers 2
