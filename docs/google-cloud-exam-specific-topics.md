# Google Cloud 認定試験別重要トピック

## Professional Cloud Architect

### 必須知識

- **アーキテクチャ設計**: Well-Architected Framework の5本柱
- **移行戦略**: 6R（Rehost、Replatform、Refactor、Repurchase、Retain、Retire）
- **ハイブリッド/マルチクラウド**: Anthos、接続オプション（VPN、Interconnect）
- **コスト最適化**: CUD、Spot VM、適切なサイジング
- **可用性設計**: SLO/SLI/SLA、RTO/RPO
- **セキュリティ**: VPC Service Controls、IAP、Binary Authorization

### 頻出シナリオ

- オンプレミスからの段階的移行計画
- グローバル展開アプリケーションの設計
- 災害復旧計画の策定
- コンプライアンス要件への対応

## Professional Cloud Developer

### 必須知識

- **アプリケーション開発**: Cloud Run、Cloud Functions、App Engine
- **API設計**: Cloud Endpoints、Apigee、RESTful設計
- **CI/CD**: Cloud Build、Cloud Deploy、Blue/Green デプロイ
- **オブザーバビリティ**: Error Reporting、Trace、Profiler、Debugger
- **データストレージ**: Firestore、Cloud SQL、使い分け
- **メッセージング**: Pub/Sub、Cloud Tasks

### 頻出シナリオ

- マイクロサービスアーキテクチャの実装
- サーバーレスアプリケーションの設計
- 非同期処理パターンの実装
- A/Bテストとカナリアリリース

## Professional Data Engineer

### 必須知識

- **データ処理**: Dataflow（Apache Beam）、Dataproc（Spark/Hadoop）
- **データウェアハウス**: BigQuery（パーティショニング、クラスタリング、マテリアライズドビュー）
- **リアルタイム処理**: Pub/Sub、Dataflow ストリーミング
- **データガバナンス**: Data Catalog、DLP、Dataplex
- **MLパイプライン**: Vertex AI、BigQuery ML
- **ETL/ELT**: データ変換パターン、スキーマ設計

### 頻出シナリオ

- バッチ処理からストリーミング処理への移行
- データレイクの構築と管理
- MLパイプラインの自動化
- データ品質管理とガバナンス

## Professional Database Engineer

### 必須知識

- **RDBMS**: Cloud SQL（MySQL、PostgreSQL、SQL Server）
- **NoSQL**: Firestore、Bigtable、Memorystore
- **NewSQL**: Cloud Spanner
- **移行**: Database Migration Service、Datastream
- **パフォーマンス**: インデックス設計、クエリ最適化
- **可用性**: レプリケーション、バックアップ戦略

### 頻出シナリオ

- オンプレミスDBからの移行計画
- グローバル分散データベースの設計
- OLTP/OLAP ワークロードの分離
- 災害復旧とバックアップ戦略

## Professional DevOps Engineer

### 必須知識

- **SRE原則**: SLO/SLI設定、エラーバジェット
- **CI/CD**: Cloud Build、Spinnaker、GitOps
- **IaC**: Terraform、Config Connector、Cloud Foundation Toolkit
- **モニタリング**: Cloud Monitoring、ログベースメトリクス
- **インシデント管理**: アラート設計、ランブック作成
- **セキュリティ**: Binary Authorization、脆弱性スキャン

### 頻出シナリオ

- ゼロダウンタイムデプロイメント
- マルチ環境管理（開発、ステージング、本番）
- 自動スケーリングとパフォーマンス最適化
- インシデント対応の自動化

## Professional Cloud Security Engineer

### 必須知識

- **IAM**: 最小権限の原則、条件付きアクセス
- **ネットワークセキュリティ**: VPC、ファイアウォール、Cloud Armor
- **データ保護**: 暗号化（CMEK/CSEK）、DLP
- **コンプライアンス**: 監査ログ、Access Transparency
- **脅威検出**: Security Command Center、Cloud IDS
- **境界セキュリティ**: VPC Service Controls、Binary Authorization

### 頻出シナリオ

- ゼロトラストアーキテクチャの実装
- 規制コンプライアンスへの対応
- セキュリティインシデント対応
- 多層防御の設計

## Professional Cloud Network Engineer

### 必須知識

- **VPC設計**: サブネット、ルーティング、ピアリング
- **ハイブリッド接続**: Cloud VPN、Interconnect（Dedicated/Partner）
- **ロードバランシング**: L4/L7、グローバル/リージョナル
- **CDN**: Cloud CDN、キャッシュ戦略
- **DNS**: Cloud DNS、Traffic Director
- **ネットワーク監視**: Network Intelligence Center、VPC Flow Logs

### 頻出シナリオ

- マルチリージョンネットワーク設計
- ハイブリッドクラウド接続
- ネットワークパフォーマンス最適化
- ネットワークセキュリティ強化

## Professional Machine Learning Engineer

### 必須知識

- **Vertex AI**: パイプライン、AutoML、カスタムトレーニング
- **MLOps**: モデルバージョニング、A/Bテスト、モニタリング
- **特徴エンジニアリング**: Feature Store、データ前処理
- **モデルサービング**: バッチ/オンライン予測、最適化
- **AI APIs**: Vision、Natural Language、Speech
- **責任あるAI**: Explainable AI、公平性、プライバシー

### 頻出シナリオ

- エンドツーエンドMLパイプラインの構築
- モデルの本番環境へのデプロイ
- リアルタイム推論システムの設計
- MLシステムのスケーリングと最適化

## 共通の試験対策ポイント

1. **ケーススタディ**: 公式のケーススタディを必ず確認
2. **ベストプラクティス**: Google推奨のアーキテクチャパターン
3. **コスト意識**: 常にコスト効率的な選択肢を検討
4. **セキュリティファースト**: デフォルトでセキュアな設計
5. **スケーラビリティ**: 将来の成長を見据えた設計
