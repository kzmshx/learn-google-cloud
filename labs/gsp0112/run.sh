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
# Download sample code
# --------------------------------
gsutil -m cp -r gs://spls/gsp067/python-docs-samples .
cd python-docs-samples/appengine/standard_python3/hello_world
sed -i 's/python37/python39/g' app.yaml

cat <<EOF >requirements.txt
Flask==1.1.2
itsdangerous==2.0.1
Jinja2==3.0.3
werkzeug==2.0.1
EOF

# --------------------------------
# Deploy App Engine app
# --------------------------------
gcloud app create --region=$REGION
gcloud app deploy
gcloud app browse
