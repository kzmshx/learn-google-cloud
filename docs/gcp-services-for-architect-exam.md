# Google Cloud Professional Cloud Architect 試験対象サービス一覧

## コンピュートサービス

### 仮想マシン・コンテナ

- **Compute Engine (GCE)**: 仮想マシンサービス
- **Google Kubernetes Engine (GKE)**: マネージドKubernetesサービス
- **Cloud Run**: サーバーレスコンテナプラットフォーム
- **Cloud Functions**: サーバーレス関数
- **App Engine**: PaaS (Platform as a Service)

### 特殊コンピュート

- **Batch**: バッチ処理サービス
- **Preemptible VMs**: 低コスト割り込み可能VM
- **Spot VMs**: 使用量ベースの低コストVM

## ストレージサービス

### オブジェクトストレージ

- **Cloud Storage (GCS)**: オブジェクトストレージ
  - Standard, Nearline, Coldline, Archive

### データベース

- **Cloud SQL**: マネージドリレーショナルDB（MySQL, PostgreSQL, SQL Server）
- **Cloud Spanner**: グローバル分散型リレーショナルDB
- **Cloud Firestore**: NoSQLドキュメントDB
- **Cloud Bigtable**: ワイドカラムNoSQLDB
- **Memorystore**: マネージドRedis/Memcached

### データウェアハウス・分析

- **BigQuery**: データウェアハウス・分析プラットフォーム
- **BigQuery ML**: BigQuery内でのML

## ネットワークサービス

### 基本ネットワーク

- **Virtual Private Cloud (VPC)**: プライベートネットワーク
- **Cloud Load Balancing**: ロードバランサー
  - HTTP(S), Network, Internal Load Balancers
- **Cloud CDN**: コンテンツ配信ネットワーク

### 接続性

- **Cloud VPN**: セキュアVPN接続
- **Cloud Interconnect**: 専用接続（Dedicated/Partner）
- **Cloud NAT**: ネットワークアドレス変換
- **Cloud Router**: 動的ルーティング

### セキュリティ

- **Cloud Armor**: DDoS保護・WAF
- **VPC Service Controls**: セキュリティ境界
- **Private Google Access**: プライベートGoogle API アクセス

## データ分析・AI/MLサービス

### データパイプライン

- **Cloud Pub/Sub**: メッセージングサービス
- **Cloud Dataflow**: ストリーミング・バッチ処理
- **Cloud Data Fusion**: データ統合プラットフォーム
- **Cloud Composer**: ワークフロー管理（Apache Airflow）
- **Dataproc**: マネージドHadoop/Spark

### AI/機械学習

- **Vertex AI**: 統合AI/MLプラットフォーム
- **AutoML**: 自動機械学習
- **AI Platform**: カスタムML（旧称）
- **Cloud Natural Language API**: 自然言語処理
- **Cloud Vision API**: 画像分析
- **Cloud Speech API**: 音声認識

### 専用AI

- **Document AI**: ドキュメント処理
- **Translation API**: 翻訳サービス
- **Recommendations AI**: レコメンデーション

## セキュリティ・アイデンティティ

### アクセス管理

- **Identity and Access Management (IAM)**: アクセス制御
- **Cloud Identity**: ID管理
- **Cloud Asset Inventory**: リソース管理

### 暗号化・キー管理

- **Cloud Key Management Service (Cloud KMS)**: 暗号化キー管理
- **Cloud Hardware Security Module (HSM)**: ハードウェアセキュリティモジュール
- **Secret Manager**: シークレット管理

### セキュリティ監視

- **Security Command Center**: セキュリティ分析
- **Cloud Security Scanner**: Webアプリケーションセキュリティ
- **Binary Authorization**: コンテナセキュリティ

## 運用・監視サービス

### Cloud Operations Suite

- **Cloud Monitoring**: 監視・アラート
- **Cloud Logging**: ログ管理
- **Cloud Trace**: 分散トレーシング
- **Cloud Profiler**: アプリケーションパフォーマンス
- **Cloud Debugger**: デバッグツール

### デプロイメント

- **Cloud Build**: CI/CDサービス
- **Cloud Source Repositories**: Gitリポジトリ
- **Cloud Deployment Manager**: インフラストラクチャ管理
- **Terraform**: インフラストラクチャのコード化

## 業界特化サービス

### ヘルスケア

- **Cloud Healthcare API**: 医療データ（HL7 FHIR, DICOM）
- **HIPAA対応**: 医療業界規制対応

### 金融サービス

- **PCI DSS対応**: 決済業界規制対応
- **Cloud Financial Services**: 金融特化

### 小売・eコマース

- **Retail API**: 小売向けAPI
- **Product Search**: 商品検索

## API・開発者ツール

### API管理

- **Cloud Endpoints**: API管理
- **API Gateway**: APIゲートウェイ
- **Apigee**: エンタープライズAPI管理

### 開発ツール

- **Cloud Shell**: ブラウザベース開発環境
- **Cloud Code**: IDE統合開発ツール
- **Cloud SDK**: コマンドラインツール

## IoTサービス

- **Cloud IoT Core**: IoTデバイス管理
- **Cloud IoT Edge**: エッジコンピューティング

## 試験頻出サービス組み合わせ

### 典型的なアーキテクチャパターン

1. **コンピュート**: GKE + Cloud Load Balancing
2. **データパイプライン**: Pub/Sub + Dataflow + BigQuery
3. **ストレージ**: Cloud Storage + Cloud SQL/Spanner
4. **セキュリティ**: IAM + Cloud KMS + VPC Service Controls
5. **監視**: Cloud Operations Suite
6. **CI/CD**: Cloud Build + Cloud Source Repositories

### ケーススタディ別重要サービス

- **TerramEarth**: IoT Core, Bigtable, Vertex AI, API Gateway
- **Mountkirk Games**: GKE, Cloud Spanner, Memorystore, Cloud CDN
- **Helicopter Racing League**: Cloud CDN, Dataflow, BigQuery, Vertex AI
- **EHR Healthcare**: GKE, Cloud Healthcare API, Cloud SQL, Cloud Monitoring

## 学習優先度

### 高優先度（必須）

- Compute Engine, GKE, Cloud Run
- Cloud Storage, Cloud SQL, BigQuery
- VPC, Cloud Load Balancing, Cloud CDN
- Pub/Sub, Dataflow
- IAM, Cloud KMS
- Cloud Operations Suite

### 中優先度

- Cloud Spanner, Bigtable, Memorystore
- Cloud VPN, Cloud Interconnect
- Vertex AI, AutoML
- Cloud Build, Cloud Endpoints

### 低優先度（業界特化）

- Cloud Healthcare API
- Industry-specific APIs
- Advanced AI services
