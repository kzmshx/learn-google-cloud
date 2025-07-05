# Google Professional Cloud Architect ケーススタディ要約

## 概要

Professional Cloud Architect 試験では、4つの主要なケーススタディが出題されます。各ケーススタディは実際のビジネスシナリオを模擬し、試験の20-30%を占めます。

## 1. TerramEarth

### 会社概要

- 重機製造会社（鉱業・農業向け）
- 100カ国に500の販売店・サービスセンター
- 200万台の稼働車両、年間20%成長

### 既存技術環境

- Google Cloud上の車両データ統合・分析インフラ
- 2つの製造拠点からのセンサーデータ
- 私設データセンターとGoogle Cloudの相互接続
- ディーラー・顧客向けWebフロントエンド

### ビジネス要件

1. **予測メンテナンス**: 車両故障予測と部品の適時配送
2. **API最新化**: レガシーシステムへのHTTP API抽象化層
3. **CI/CDパイプライン最新化**: コンテナベースワークロード対応
4. **セキュリティ管理**: クラウドネイティブなキー・シークレット管理
5. **監視・トラブルシューティング**: 統一された監視ツール

### 推奨ソリューション

- **データ取り込み**: Cloud IoT Core、Pub/Sub、Dataflow
- **リアルタイム分析**: Bigtable、BigQuery
- **機械学習**: Vertex AI（予測分析）
- **API管理**: API Gateway、Cloud Endpoints
- **CI/CD**: Cloud Build、Cloud Source Repositories
- **セキュリティ**: Cloud KMS、Secret Manager
- **監視**: Cloud Operations Suite

## 2. Mountkirk Games

### 会社概要

- モバイルゲーム開発会社
- オンライン・セッションベース・マルチプレイヤーゲーム
- 複数プラットフォームに展開中

### 既存技術環境

- Google Cloudに最近移行済み
- ゲーム毎に個別クラウドプロジェクト
- 開発・テスト環境の分離
- Kubernetes使用

### ビジネス要件

1. **グローバル展開**: 複数地域・プラットフォーム対応
2. **低レイテンシ**: 最優先事項
3. **スケーラビリティ**: 動的スケーリング
4. **高度な分析**: リアルタイム分析機能
5. **コスト最適化**: インフラコスト最小化

### 推奨ソリューション

- **コンテナ管理**: Google Kubernetes Engine (GKE)
- **ロードバランシング**: Global HTTP Load Balancer
- **データベース**: Cloud Spanner（マルチリージョン）
- **リアルタイム処理**: Pub/Sub、Dataflow
- **分析**: BigQuery
- **GPU処理**: Preemptible GPU nodes
- **リーダーボード**: Cloud Memorystore

## 3. Helicopter Racing League (HRL)

### 会社概要

- グローバルヘリコプターレーシングリーグ
- 世界選手権および地域リーグ運営
- 有料ライブストリーミングサービス

### 既存技術環境

- 現行プラットフォームは基本的な予測機能のみ
- TensorFlow使用の予測システム
- トラック搭載のモバイルデータセンター
- 動画録画・編集をクラウドで実行

### ビジネス要件

1. **予測機能向上**: レース結果、機械故障、観客反応
2. **ストリーミング品質**: グローバル配信品質・同時視聴者数向上
3. **リアルタイム分析**: 視聴パターンとエンゲージメント分析
4. **データマート**: 大量のレースデータ処理
5. **コスト効率**: レースデータ保存の最適化

### 推奨ソリューション

- **動画配信**: Cloud CDN、Transcoding API
- **データ処理**: Cloud Dataflow、BigQuery
- **機械学習**: Vertex AI、Natural Language Processing
- **インフラ**: Multi-regional GKE cluster
- **ストレージ**: Cloud Storage（ライフサイクル管理）
- **監視**: Cloud Monitoring

## 4. EHR Healthcare

### 会社概要

- 電子健康記録（EHR）ソフトウェアの大手プロバイダー
- 多国籍医療機関・病院・保険会社にSaaS提供
- 急速な事業成長

### 既存技術環境

- 複数のコロケーション施設でホスティング
- コンテナ化されたWebアプリケーション
- 混在データベース（MySQL、MS SQL Server、Redis、MongoDB）
- Microsoft Active Directoryによるユーザー管理

### ビジネス要件

1. **高可用性**: 最低99.9%の稼働率
2. **可視性**: 統一されたシステム性能監視
3. **コスト削減**: インフラ管理コストの削減
4. **規制遵守**: 医療規制の継続的な遵守
5. **分析**: 業界トレンドの予測・レポート生成

### 推奨ソリューション

- **コンテナ管理**: Google Kubernetes Engine (GKE)
- **監視**: Cloud Monitoring、Cloud Logging
- **データ分析**: BigQuery
- **ネットワーク**: Cloud VPN/Interconnect
- **コンプライアンス**: Cloud Healthcare API
- **データベース**: Cloud SQL、Memorystore、Cloud Datastore

## 試験対策のポイント

### 共通アーキテクチャパターン

1. **マイクロサービス**: GKE + コンテナ化
2. **データパイプライン**: Pub/Sub + Dataflow + BigQuery
3. **機械学習**: Vertex AI
4. **API管理**: API Gateway + Cloud Endpoints
5. **監視**: Cloud Operations Suite

### 業界別特化

- **IoT/製造業**: TerramEarth（IoT Core、予測分析）
- **ゲーミング**: Mountkirk Games（低レイテンシ、リアルタイム分析）
- **メディア/ストリーミング**: HRL（CDN、動画処理）
- **ヘルスケア**: EHR Healthcare（コンプライアンス、高可用性）

### 重要な考慮事項

- **グローバルスケール**: Multi-regional deployment
- **コスト最適化**: Preemptible instances、適切なストレージクラス
- **セキュリティ**: IAM、暗号化、VPC設計
- **パフォーマンス**: CDN、キャッシュ、データベース最適化
- **可用性**: 冗長化、災害復旧、SLA要件
