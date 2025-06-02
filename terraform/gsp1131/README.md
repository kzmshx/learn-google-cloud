# GSP1131

## 作業フロー

Terraform リソースを作成する。

```sh
make init
make plan
make apply
```

Cloud Shell をセットアップする。

```sh
PROJECT_ID=${GOOGLE_CLOUD_PROJECT}
REGION=<REGION>
echo $PROJECT_ID, $REGION
```

Artifact Registry の認証を設定する。

```sh
DOCKER_REGISTRY_HOST=${REGION}-docker.pkg.dev
DOCKER_REGISTRY_REPO_URL=${DOCKER_REGISTRY_HOST}/${PROJECT_ID}/example-docker-repo
gcloud auth configure-docker ${DOCKER_REGISTRY_HOST}
```

イメージを Pull し、リポジトリに Push し、リポジトリから Pull する。

```sh
PUBLIC_IMAGE_URL=us-docker.pkg.dev/google-samples/containers/gke/hello-app:1.0
MY_IMAGE_URL=${DOCKER_REGISTRY_REPO_URL}/sample-image:tag1
docker pull ${PUBLIC_IMAGE_URL}
docker tag ${PUBLIC_IMAGE_URL} ${MY_IMAGE_URL}
docker push ${MY_IMAGE_URL}
docker pull ${MY_IMAGE_URL}
```
