# Professional Cloud Architect 試験対策 - サービス優先度マトリックス

## 最重要サービス（Priority 1）- 必須習得

### コンピュート

| サービス | 重要度 | 理由 | 主な使用ケース |
|----------|--------|------|----------------|
| **Google Kubernetes Engine (GKE)** | ★★★★★ | 全ケーススタディで使用、コンテナ化の中心 | Mountkirk Games, EHR Healthcare |
| **Compute Engine** | ★★★★★ | 基本的な仮想マシン、他サービスの基盤 | TerramEarth, すべてのケース |
| **Cloud Run** | ★★★★☆ | サーバーレスコンテナ、モダンアプリケーション | API層、マイクロサービス |

### ストレージ・データベース

| サービス | 重要度 | 理由 | 主な使用ケース |
|----------|--------|------|----------------|
| **BigQuery** | ★★★★★ | 全ケーススタディで分析に使用 | TerramEarth, Mountkirk Games, HRL |
| **Cloud Storage** | ★★★★★ | 基本的なオブジェクトストレージ | 全ケーススタディ |
| **Cloud SQL** | ★★★★☆ | 基本的なリレーショナルDB | EHR Healthcare,一般的なWebアプリ |
| **Cloud Spanner** | ★★★★☆ | グローバルゲーミングで必須 | Mountkirk Games |

### ネットワーク

| サービス | 重要度 | 理由 | 主な使用ケース |
|----------|--------|------|----------------|
| **VPC (Virtual Private Cloud)** | ★★★★★ | すべてのネットワーク設計の基盤 | 全ケーススタディ |
| **Cloud Load Balancing** | ★★★★★ | 高可用性、グローバル分散 | 全ケーススタディ |
| **Cloud CDN** | ★★★★☆ | グローバル配信、低レイテンシ | HRL, Mountkirk Games |

### データ処理

| サービス | 重要度 | 理由 | 主な使用ケース |
|----------|--------|------|----------------|
| **Cloud Pub/Sub** | ★★★★★ | リアルタイム処理の入り口 | 全ケーススタディ |
| **Cloud Dataflow** | ★★★★★ | ストリーミング・バッチ処理 | 全ケーススタディ |

### セキュリティ

| サービス | 重要度 | 理由 | 主な使用ケース |
|----------|--------|------|----------------|
| **IAM** | ★★★★★ | セキュリティの基盤 | 全ケーススタディ |
| **Cloud KMS** | ★★★★☆ | 暗号化、規制対応 | EHR Healthcare, 企業要件 |

### 監視・運用

| サービス | 重要度 | 理由 | 主な使用ケース |
|----------|--------|------|----------------|
| **Cloud Operations Suite** | ★★★★★ | 監視・ログ・デバッグ | 全ケーススタディ |

## 重要サービス（Priority 2）- 推奨習得

### コンピュート・AI/ML

| サービス | 重要度 | 理由 | 主な使用ケース |
|----------|--------|------|----------------|
| **Vertex AI** | ★★★★☆ | 機械学習・予測分析 | TerramEarth, HRL |
| **App Engine** | ★★★☆☆ | 従来のPaaS、レガシー移行 | 一般的なWebアプリ |

### ストレージ・データベース

| サービス | 重要度 | 理由 | 主な使用ケース |
|----------|--------|------|----------------|
| **Cloud Bigtable** | ★★★★☆ | 大規模IoTデータ | TerramEarth |
| **Cloud Firestore** | ★★★☆☆ | モバイルアプリ、リアルタイム | Mountkirk Games |
| **Memorystore** | ★★★☆☆ | 低レイテンシキャッシュ | Mountkirk Games |

### ネットワーク

| サービス | 重要度 | 理由 | 主な使用ケース |
|----------|--------|------|----------------|
| **Cloud VPN** | ★★★★☆ | ハイブリッド接続 | TerramEarth |
| **Cloud Interconnect** | ★★★★☆ | 専用接続 | 大企業、高トラフィック |
| **Cloud Armor** | ★★★☆☆ | DDoS保護、WAF | Webアプリケーション |

### 開発・API

| サービス | 重要度 | 理由 | 主な使用ケース |
|----------|--------|------|----------------|
| **Cloud Build** | ★★★★☆ | CI/CD、DevOps | 全ケーススタディ |
| **API Gateway** | ★★★★☆ | API管理、マイクロサービス | TerramEarth |
| **Cloud Endpoints** | ★★★☆☆ | API管理 | 内部API |

### 業界特化

| サービス | 重要度 | 理由 | 主な使用ケース |
|----------|--------|------|----------------|
| **Cloud Healthcare API** | ★★★☆☆ | 医療業界特化 | EHR Healthcare |
| **Cloud IoT Core** | ★★★☆☆ | IoTデバイス管理 | TerramEarth |

## 補完サービス（Priority 3）- 選択的習得

### 特殊用途

| サービス | 重要度 | 理由 | 主な使用ケース |
|----------|--------|------|----------------|
| **Cloud Functions** | ★★★☆☆ | 軽量サーバーレス | イベント処理 |
| **Cloud Composer** | ★★☆☆☆ | 複雑なワークフロー | データパイプライン |
| **Cloud Data Fusion** | ★★☆☆☆ | ノーコードETL | データ統合 |

### 高度なAI/ML

| サービス | 重要度 | 理由 | 主な使用ケース |
|----------|--------|------|----------------|
| **AutoML** | ★★☆☆☆ | 自動機械学習 | カスタムML |
| **Vision/Speech/NLP API** | ★★☆☆☆ | 事前構築済みAI | 特定用途 |

## 学習ロードマップ

### Phase 1: 基盤サービス（2-3週間）

1. **コンピュート**: GKE, Compute Engine
2. **ストレージ**: BigQuery, Cloud Storage, Cloud SQL
3. **ネットワーク**: VPC, Load Balancing
4. **セキュリティ**: IAM

### Phase 2: データ処理（2週間）

1. **リアルタイム処理**: Pub/Sub, Dataflow
2. **分析**: BigQuery詳細
3. **監視**: Cloud Operations Suite

### Phase 3: 高度なサービス（2-3週間）

1. **機械学習**: Vertex AI
2. **専用サービス**: Bigtable, Spanner
3. **ネットワーク**: VPN, Interconnect, CDN

### Phase 4: ケーススタディ特化（1-2週間）

1. **TerramEarth**: IoT Core, 予測分析
2. **Mountkirk Games**: リアルタイム処理、キャッシュ
3. **HRL**: ストリーミング、AI/ML
4. **EHR Healthcare**: コンプライアンス、高可用性

### Phase 5: 統合・実践（1週間）

1. **アーキテクチャ設計**: 複数サービス組み合わせ
2. **ベストプラクティス**: セキュリティ、コスト最適化
3. **模擬試験**: 実践的な問題演習

## 学習リソース優先度

### 必須リソース

- Google Cloud公式ドキュメント（各サービス）
- ケーススタディ詳細分析
- Qwiklabs（ハンズオン）
- 公式模擬試験

### 推奨リソース

- Coursera Professional Cloud Architect Course
- A Cloud Guru / Linux Academy
- ExamTopics（実際の試験問題）
- YouTube（Google Cloud Tech）

### 補完リソース

- Medium技術記事
- GitHub実装例
- コミュニティフォーラム
- 技術書籍
