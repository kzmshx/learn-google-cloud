# Google Cloud クイックリファレンス

## コンピューティング選択フローチャート

```
アプリケーション要件
├─ コンテナ化されている？
│  ├─ Yes → HTTP(S)ベース？
│  │  ├─ Yes → Cloud Run
│  │  └─ No → GKE
│  └─ No → サーバーレス希望？
│     ├─ Yes → Cloud Functions
│     └─ No → Compute Engine
```

## データベース選択ガイド

| 要件 | 推奨サービス |
|------|------------|
| RDBMS（単一リージョン） | Cloud SQL |
| RDBMS（グローバル） | Cloud Spanner |
| ドキュメントDB（モバイル） | Firestore Native |
| ドキュメントDB（サーバー） | Firestore Datastore |
| 時系列/IoT | Bigtable |
| インメモリキャッシュ | Memorystore |
| データウェアハウス | BigQuery |

## ストレージクラス早見表

| クラス | アクセス頻度 | 最小保存期間 | 用途例 |
|--------|------------|------------|--------|
| Standard | 頻繁 | なし | アクティブデータ |
| Nearline | 月1回 | 30日 | バックアップ |
| Coldline | 四半期1回 | 90日 | アーカイブ |
| Archive | 年1回 | 365日 | 長期保管 |

## ネットワーク接続オプション

| 方式 | 帯域幅 | レイテンシ | 用途 |
|------|--------|-----------|------|
| インターネット | 変動 | 高 | 一般接続 |
| Cloud VPN | ～3Gbps | 中 | セキュア接続 |
| Partner Interconnect | 50Mbps-10Gbps | 低 | 専用接続 |
| Dedicated Interconnect | 10-100Gbps | 最低 | 大容量転送 |

## IAM ロール階層

```
組織
└─ フォルダ
   └─ プロジェクト
      └─ リソース
```

※ 上位で付与された権限は下位に継承される

## コスト削減チェックリスト

- [ ] 不要なリソースの削除
- [ ] 適切なマシンタイプ選択
- [ ] CUD（確約利用割引）の活用
- [ ] Spot VM の利用検討
- [ ] ストレージクラスの最適化
- [ ] ネットワーク下り転送の最小化
- [ ] リソースのスケジューリング

## セキュリティチェックリスト

- [ ] 最小権限の原則（IAM）
- [ ] ネットワーク分離（VPC）
- [ ] 保存時暗号化（CMEK）
- [ ] 転送時暗号化（TLS）
- [ ] 監査ログの有効化
- [ ] VPC Service Controls
- [ ] Binary Authorization
- [ ] DLP によるデータスキャン

## 障害対策レベル

| レベル | 構成 | RTO | RPO | コスト |
|--------|------|-----|-----|--------|
| 基本 | 単一ゾーン | 時間 | 日 | 低 |
| 標準 | マルチゾーン | 分 | 時間 | 中 |
| 高度 | マルチリージョン | 秒 | 分 | 高 |

## よく使うgcloudコマンド

```bash
# 認証・設定
gcloud auth list
gcloud config list
gcloud config set project PROJECT_ID

# Compute Engine
gcloud compute instances list
gcloud compute instances create INSTANCE_NAME
gcloud compute ssh INSTANCE_NAME

# GKE
gcloud container clusters list
gcloud container clusters get-credentials CLUSTER_NAME

# Cloud Run
gcloud run services list
gcloud run deploy SERVICE_NAME --image IMAGE_URL

# IAM
gcloud projects get-iam-policy PROJECT_ID
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="user:email@example.com" \
  --role="roles/viewer"
```

## Terraform 基本構文

```hcl
# プロバイダー設定
provider "google" {
  project = "PROJECT_ID"
  region  = "us-central1"
}

# リソース定義
resource "google_compute_instance" "default" {
  name         = "instance-name"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {}  # External IP
  }
}
```

## 一般的なエラーと対処法

| エラー | 原因 | 対処法 |
|--------|------|--------|
| 403 Forbidden | 権限不足 | IAMロール確認 |
| 409 Conflict | リソース競合 | リソース名変更 |
| 429 Too Many Requests | レート制限 | リトライ実装 |
| 500 Internal Error | サービス障害 | 時間をおいて再試行 |

## サービス制限値（デフォルト）

| サービス | 制限項目 | デフォルト値 |
|----------|---------|------------|
| Compute Engine | CPUコア/プロジェクト | 24 |
| Cloud Run | 同時実行数 | 1000 |
| GKE | ノード/クラスタ | 1000 |
| Cloud SQL | インスタンス/プロジェクト | 40 |
| BigQuery | 同時クエリ | 100 |

※ 制限値は申請により拡張可能
