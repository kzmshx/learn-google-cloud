# Google Cloud 認定試験チートシート

## 概要

このチートシートは、Google Cloud 認定試験（Professional Cloud Architect、Cloud Developer、Data Engineer など）の準備のために作成されました。

## 試験一覧と優先順位

1. Cloud Architect
2. Cloud Developer
3. Database Engineer
4. Data Engineer
5. DevOps Engineer
6. Security Engineer
7. Network Engineer
8. Machine Learning Engineer

## 重要概念・サービス一覧

### Compute

#### Cloud Run

- **基盤**: knative ベース（services/jobs）、Gen1: gVisor、Gen2: microVM
- **4つのタイプ**:
  - services: HTTP(S)リクエストベース、コンテナイメージ実行
  - jobs: 任意タイミング実行、60分以上実行可能、並列処理対応
  - functions: HTTP/トリガーベースのイベント駆動、ランタイム制約あり
  - worker pools: pull型ワークロード（Pub/Sub、Kafka連携）※プレビュー版
- **スケーリング**: デフォルト 0-100、上限デフォルト1000（申請で拡大可）
- **ネットワーク**: VPC外で動作、VPC内リソースへのアクセスには「サーバーレスVPCアクセス」または「Direct VPC Egress」が必要
- **課金**: リクエストベース / インスタンスベース
- **無料枠**: 180,000 vCPU秒、360,000 GiB秒、200万リクエスト/月
- **コールドスタート対策**: 最小インスタンス設定、Startup CPU boost
- **通信プロトコル**: HTTP、gRPC、WebSocket対応
- **統合**: Pub/Sub、Cloud Scheduler、Cloud Tasksトリガー対応

#### Kubernetes Engine (GKE)

- **Operation Mode**: Autopilot, Standard
- **Availability Mode**: Single-zone, Multi-zone, Regional
- **Network Mode**: VPC Native, Route Based
- **Upgrading Strategy**: Rapid, Regular, Stable
- **認証**: Workload Identity Federation（新旧2種類）
  - 旧: IAM SAをKubernetes SAに紐付け
  - 新: GKE SAに直接IAMロール付与

#### Compute Engine

- **ストレージタイプ**:
  - Persistent Disk: 不揮発性、Standard/Balanced/Performance/Extreme
  - Hyperdisk: 不揮発性、用途別最適化
  - Local SSD: 揮発性、高速I/O、低レイテンシー

### Database

#### Cloud SQL

- **特徴**: マネージドRDBMS（MySQL、PostgreSQL、SQL Server）
- **バックアップ**: PITR（ポイントインタイムリカバリ）、7日間任意時点復旧可能
- **エクスポート**: サーバーレスエクスポート（大規模単発）、リードレプリカ（頻繁）
- **最適化**: Recommender API、slow_query_log、Query Insights
- **高可用性**: 自動フェイルオーバー60秒以内、Enterprise Plusで1秒未満
- **エディション**: Standard、Enterprise、Enterprise Plus
- **レプリケーション**: リードレプリカ（同一/クロスリージョン）
- **セキュリティ**: IAM認証、SSL/TLS、CMEK対応、監査ログ
- **料金**: 秒単位課金、確約利用割引（最大52%）

#### Cloud Spanner

- **特徴**: グローバル分散、強整合性、99.999%可用性
- **使い分け**: Cloud SQLが複数リージョン高可用性を実現できない場合に利用
- **最適化**: インターリーブによるデータ局所性向上
- **レプリカタイプ**: 読み書き、読み取り専用、ウィットネス（投票のみ）
- **スケーリング**: 水平スケーリング、自動シャーディング
- **プライマリキー設計**: 連続値を避ける（ホットスポット防止）
- **SQL方言**: GoogleSQL、PostgreSQL互換
- **分析機能**: Data Boost（本番ワークロード影響なし）
- **料金**: 処理ユニット（100単位）＋ストレージ、確約利用割引40%

#### Firestore

- **Native mode**: モバイル/ウェブ向け、リアルタイム機能、オフライン同期
- **Datastore mode**: サーバーサイド向け、App Engine統合

#### Bigtable

- **特徴**: NoSQL、高スループット
- **設計**: ホットスポット回避（単調増加キーを避ける）
- **分析**: Key Visualizer でパフォーマンス問題特定

### Networking

#### VPC

- **サブネット**: リージョン間でもデフォルトで通信可能
- **アクセス制御**:
  - 限定公開のGoogleアクセス: External IPなしでPublic APIアクセス
  - Private Service Connect: VPC間のIP重複を回避
  - VPC Service Controls: APIレベルのアクセス境界設定

#### ロードバランサー

- **Global**: CDN、Cloud Armor対応、Pre-warming不要
- **Regional**: CDN、Armor未対応
- **構成要素**: Forwarding Rule → Target Proxy → URL map → Backend Service

#### 接続オプション

- **Cloud VPN**: IPSec暗号化、インターネット経由
- **Dedicated Interconnect**: 専用物理接続、10GB以上
- **Partner Interconnect**: パートナー経由接続

### Storage & Data Transfer

#### Cloud Storage

- **クラス**: Standard → Nearline → Coldline → Archive（料金↓、アクセス料金↑）
- **セキュリティ**: 署名付きURL、バケットロック
- **最適化**: 並列アップロード/ダウンロード、ファイル命名戦略

#### データ転送

- **Storage Transfer Service**: 10TB未満、継続転送可能
- **Transfer Appliance**: 10TB以上、単発転送
- **Database Migration Service**: DB移行専用、最小ダウンタイム
- **Datastream**: リアルタイムレプリケーション

### セキュリティ

#### IAM

- **構造**: リソース → IAMポリシー → バインディング（プリンシパル+ロール+条件）
- **外部連携**: Workload Identity Federation（AWS/他クラウドからのアクセス）

#### データ保護

- **Sensitive Data Protection (旧DLP)**: PII検出、匿名化（マスキング、トークン化等）
- **暗号化**: デフォルト透過的暗号化、CMEK/CSEK対応

#### ネットワークセキュリティ

- **Cloud Armor**: DDoS防御、WAFルール
- **VPC Service Controls**: APIレベルの境界設定
- **Binary Authorization**: デプロイ時の署名検証

### 監視・運用

#### オブザーバビリティ

- **Cloud Monitoring**: メトリクス監視
- **Cloud Logging**: ログ収集、シンク設定
- **Cloud Trace**: 分散トレース
- **Cloud Profiler**: パフォーマンス分析

#### CI/CD

- **Cloud Build**: ビルド自動化、ステップ間データ共有は永続ファイルシステム利用
- **Cloud Deploy**: Kubernetesデプロイ管理
- **Artifact Registry**: コンテナ/パッケージ管理

### データ分析・AI/ML

#### ETL/データ処理

- **Dataflow**: ストリーミング/バッチ処理、Apache Beam
  - ホッピングウィンドウで移動平均計算可能
  - 自動スケーリング、フルマネージド
- **Dataproc**: Spark/Hadoop、自動スケーリング
  - Apache Flink、Presto対応
  - ジョブあたりの課金モデル
- **Pub/Sub**: メッセージング、pull/push両対応
  - 1Topic→1Subscriber: 同一処理の並列実行
  - 1Topic→複数Subscriber: 異なる処理の独立実行
  - 最低1回配信保証
- **Cloud Composer**: Apache Airflow、ワークフロー管理
- **Dataplex**: データレイク管理、統合メタデータ

#### AI/ML

- **Vertex AI**: 統合ML プラットフォーム
  - Training: モデル学習
  - Model Registry: モデル管理
  - Endpoints: モデルデプロイ
  - Batch Prediction: バッチ推論
  - Explainable AI: 予測説明
  - ML Metadata: 実験追跡
- **AutoML**: 転移学習ベース、少ないデータで高精度
- **BigQuery ML**: SQL でML、大量データ必要
- **Document AI**: 画像からテキスト抽出
- **Natural Language API**: テキスト分析（感情分析、エンティティ抽出）
- **Vision AI/Video AI**: 画像・動画分析

## アーキテクチャパターン

### 疎結合アーキテクチャ

- **中核サービス**: Pub/Sub、Cloud Tasks
- **メリット**: 独立スケーリング、高可用性、保守性向上
- **実装パターン**:
  - ファンアウトメッセージング
  - イベント駆動処理
  - 非同期処理パイプライン
- **設計原則**:
  - At-least-once配信を前提に冪等性を確保
  - メッセージ順序が必要な場合は明示的に設計
  - プロデューサー/コンシューマーの独立性維持

### Well-Architected Framework

1. **運用の卓越性**: 自動化、モニタリング、継続的改善
2. **セキュリティ、プライバシー、コンプライアンス**: ゼロトラスト、暗号化、監査
3. **信頼性**: 高可用性、災害復旧、自動スケーリング
4. **コスト最適化**: 適切なサイジング、自動化、確約利用
5. **パフォーマンス最適化**: キャッシング、CDN、負荷分散

### デプロイメントアーキタイプ

- **ゾーン**: 単一ゾーン内デプロイ
- **リージョン**: リージョン内冗長性
- **マルチリージョン**: グローバル高可用性
- **ハイブリッド**: オンプレミス連携
- **マルチクラウド**: 複数クラウド統合

## 試験対策のポイント

### 共通して重要な概念

1. **責任共有モデル**の理解
2. **ネットワーク設計**（VPC、サブネット、ファイアウォール）
3. **IAMとセキュリティ**のベストプラクティス
4. **可用性とスケーラビリティ**の設計
5. **コスト最適化**（CUD、Spot VM等）
6. **疎結合設計**によるレジリエンス向上
7. **Well-Architected Framework**の5本柱

### 試験別重点分野

- **Cloud Architect**: 全体アーキテクチャ、移行戦略
- **Cloud Developer**: アプリケーション開発、API設計
- **Data Engineer**: データパイプライン、BigQuery
- **Security Engineer**: VPC Service Controls、暗号化
- **Network Engineer**: ハイブリッド接続、ロードバランシング

### 試験で注意すべきポイント

1. **Cloud Run**:
   - 実行環境の違い（Gen1 vs Gen2）を理解
   - ネットワークイングレス設定オプション
   - 認証・セキュリティ設定方法
2. **Cloud SQL vs Cloud Spanner**:
   - Cloud SQL: 従来型RDBMS、リージョナル
   - Cloud Spanner: グローバル分散、水平スケール
3. **データベースバージョン選択**: 一度選択すると変更不可
4. **疎結合設計**: Pub/SubとCloud Tasksの使い分け
5. **ネットワーク設計**: VPC外サービスへのアクセス方法

## 重要な追加概念

### 運用・管理

#### コスト最適化

- **確約利用割引（CUD）**:
  - リソースベース: プロジェクト単位、Compute Engine系のみ
  - フレキシブル: 請求先アカウント単位、対象マシンタイプのみ
  - 1年または3年契約、最大57%割引
- **Spot VM**: Preemptible VMの後継、最長使用時間制限なし
- **ライブマイグレーション**: 約0.5秒停止でホスト間移行、パケットロスなし

#### リソース管理

- **Resource Manager**: 組織、フォルダ、プロジェクトの階層管理
- **割り当て管理**: API制限、リソース上限の管理
- **Cloud Billing**: 予算アラート、エクスポート機能

### 開発者ツール

#### API管理

- **Cloud Endpoints**: API Gateway（ESP/ESPv2）
- **Apigee**: エンタープライズAPIマネジメント
- **API Keys**: シンプルなAPI認証

#### ワークフロー

- **Cloud Workflows**: サーバーレスワークフロー
- **Cloud Scheduler**: cronジョブ管理
- **Cloud Tasks**: 非同期タスクキュー

### 移行ツール

- **Migrate for Compute Engine**: VM移行
- **Database Migration Service**: 最小ダウンタイムDB移行
- **BigQuery Data Transfer Service**: 定期的なデータ取り込み

### 特殊用途サービス

#### エッジコンピューティング

- **Anthos**: マルチクラウド・オンプレミスKubernetes
- **Edge TPU**: エッジAI推論

#### メディア処理

- **Transcoder API**: 動画変換
- **Live Stream API**: ライブストリーミング

#### IoT

- **IoT Core**: デバイス管理・データ取り込み

## よくある設計パターンと解決策

### 高可用性パターン

1. **マルチゾーン構成**:
   - GKE Regional クラスタ
   - Cloud SQL 高可用性構成
   - Cloud Storage マルチリージョン

2. **グローバル負荷分散**:
   - Global Load Balancer + Cloud CDN
   - Multi-region Cloud Spanner
   - Pub/Sub によるリージョン間連携

### セキュリティパターン

1. **ゼロトラスト**:
   - Identity-Aware Proxy (IAP)
   - VPC Service Controls
   - Binary Authorization

2. **データ保護**:
   - CMEK/CSEK による暗号化
   - DLP API による機密データ検出
   - Cloud HSM による鍵管理

### コスト最適化パターン

1. **自動スケーリング**:
   - Cloud Run 0スケール
   - GKE Autopilot
   - Dataflow 自動スケーリング

2. **階層型ストレージ**:
   - Cloud Storage ライフサイクル
   - BigQuery パーティショニング
   - Firestore TTL

## 試験頻出シナリオ

### 移行シナリオ

- **リフト＆シフト**: Migrate for Compute Engine
- **リファクタリング**: コンテナ化してGKE/Cloud Run
- **リプラットフォーム**: マネージドサービスへ移行

### 障害対策シナリオ

- **RTO/RPO要件**: バックアップ戦略選択
- **災害復旧**: マルチリージョン構成
- **自動フェイルオーバー**: Cloud SQL HA、GKE Regional

### パフォーマンス改善

- **キャッシング**: Memorystore、CDN
- **データ局所性**: Cloud Spanner インターリーブ
- **並列処理**: Dataflow、Cloud Tasks

## 参考リソース

- [Google Cloud アーキテクチャフレームワーク](https://cloud.google.com/architecture)
- [Solution Design Pattern](https://www.gc-solution-design-pattern.jp/)
- [Google SRE Books](https://sre.google/books/)
- [AWS/Azure/GCP サービス比較](https://cloud.google.com/docs/get-started/aws-azure-gcp-service-comparison)
- [Google Cloud 認定試験ガイド](https://cloud.google.com/learn/certification)
