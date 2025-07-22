# GSP1077

結論を言えば、このラボはチェックポイントを通過できない、かつその理由が不当なものであったため断念。
ただし作ったリソースは参考になるものがあったためファイル群は残しておく。

## 概要

ソースリポジトリへの Push に応じて、テストを実行しコンテナイメージをビルドして、イメージリポジトリに Push する。
イメージリポジトリへの Push に応じて Deployment マニフェストを更新し、マニフェストリポジトリに Push する。
マニフェストリポジトリへの Push に応じてマニフェストを GKE クラスターにデプロイする。

## 構築するもの

- Kubernetes Engine クラスター
- Cloud Source Repositories のリポジトリ（app, env）
- Cloud Source Repositories からの Cloud Build トリガー
- Cloud Build による自動テスト実行、コンテナイメージのビルド、レジストリへのプッシュ
- Cloud Build による Kubernetes Engine クラスターへの変更のデプロイ

## 作業フロー

terraform apply

```sh
make init
make plan
make apply
```

シェル環境をセットアップ

```sh
export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')
export REGION=<region>

gcloud config set compute/region $REGION

git config --global user.email <email>
git config --global user.name <name>
```

GitHub リポジトリをクローン

```sh
git clone https://github.com/GoogleCloudPlatform/gke-gitops-tutorial-cloudbuild hello-cloudbuild-app
```

Cloud Source Repositories を app リポジトリのリモートとして構成

```sh
cd ./hello-cloudbuild-app
sed -i "s/us-central1/$REGION/g" cloudbuild.yaml
sed -i "s/us-central1/$REGION/g" cloudbuild-delivery.yaml
sed -i "s/us-central1/$REGION/g" cloudbuild-trigger-cd.yaml
sed -i "s/us-central1/$REGION/g" kubernetes.yaml.tpl
git remote add google "https://source.developers.google.com/p/${PROJECT_ID}/r/hello-cloudbuild-app"
```

Cloud Build の実行を試す

```sh
COMMIT_ID="$(git rev-parse --short=7 HEAD)"
gcloud builds submit --tag="${REGION}-docker.pkg.dev/${PROJECT_ID}/my-repository/hello-cloudbuild:${COMMIT_ID}" .
```

Cloud Source Repositories に変更を Push する（Cloud Build パイプラインをトリガーする）

```sh
git add .
git commit -m "Test commit"
git push google master
```

env リポジトリを初期化

```sh
cd ..
gcloud source repos clone hello-cloudbuild-env
cd ./hello-cloudbuild-env
git checkout -b production
cp ../hello-cloudbuild-app/cloudbuild-delivery.yaml ./cloudbuild.yaml
git add .
git commit -m "Create cloudbuild.yaml for deployment"
git checkout -b candidate
git push origin production
git push origin candidate
```

app リポジトリの codebuild.yaml を作成

```sh
cd ../hello-cloudbuild-app
cp cloudbuild-trigger-cd.yaml cloudbuild.yaml
git add codebuild.yaml
git commit -m "Trigger CD pipeline"
git push google master
```

app リポジトリの変更を Push （パイプライン全体をトリガーする）

```sh
sed -i 's/Hello World/Hello Cloud Build/g' app.py
sed -i 's/Hello World/Hello Cloud Build/g' test_app.py
git add app.py test_app.py
git commit -m "Hello Cloud Build"
git push google master
```
