# Google Cloud Bootcamp

Archived: No
Created At: May 15, 2025 4:03 PM
TOC: - Google Cloud Bootcamp
- 計画
- トピック
- ログ
- 2025-07-05
- 2025-07-04
- 2025-07-03
- 2025-07-02
- 2025-07-01
- 2025-06-30
- 2025-06-29
- 2025-06-28
- 2025-06-27
- 2025-06-26
- 2025-06-25
- 2025-06-24
- 2025-06-23
- 2025-06-22
- 2025-05-23
- 2025-05-19
- 2025-05-15
Updated At: July 5, 2025 4:47 PM

# 計画

- 残期間
    - 今日：2025-07-04
    - 受験締切日：2025-08-24
    - 合計：51日
- 受験順
    - Cloud Architect
    - Cloud Developer
    - Database Engineer
    - Data Engineer
    - DevOps Engineer
    - Security Engineer
    - Network Engineer
    - Machine Learning Engineer

# トピック

- Compute
    - Cloud Run
        - services
            - https://blog.g-gen.co.jp/entry/cloud-run-explained
            - https://blog.g-gen.co.jp/entry/introduction-to-cloud-run-service
        - functions
            - https://blog.g-gen.co.jp/entry/cloud-functions-explained
            - https://blog.g-gen.co.jp/entry/cloud-run-functions-rebranding
    - Kubernetes Engine
        - https://blog.g-gen.co.jp/archive/category/Google%20Kubernetes%20Engine%20%28GKE%29
        - 色々摘んで読むことで全体像を得る
- Database
    - Bigtable
        - https://blog.g-gen.co.jp/entry/bigtable-explained
    - Cloud SQL
        - https://blog.g-gen.co.jp/entry/cloud-sql-explained
        - https://blog.g-gen.co.jp/entry/migrate-databases-to-google-cloud
        - https://blog.g-gen.co.jp/entry/trial-for-gemini-in-database
    - Cloud Spanner
        - https://blog.g-gen.co.jp/entry/cloud-spanner-explained
        - https://g-gen.co.jp/useful/google-service/16986/
        - https://blog.g-gen.co.jp/entry/spanner-tiered-storage-explained
        - https://g-gen.co.jp/useful/google-service/24294/
        - https://blog.g-gen.co.jp/entry/spanner-managed-autoscaler-explained
    - Firestore
        - https://blog.g-gen.co.jp/entry/firebase-explained
    - Memorystore
        - https://blog.g-gen.co.jp/entry/serverless-architecture-explained
- ETL
    - Dataflow
        - https://blog.g-gen.co.jp/entry/dataflow-explained
        - https://g-gen.co.jp/useful/google-service/15019/
    - Dataproc
        - https://g-gen.co.jp/useful/google-service/20017/
        - https://g-gen.co.jp/useful/google-service/13969/
        - https://blog.g-gen.co.jp/entry/data-catalog-explained
    - Dataplex
        - https://blog.g-gen.co.jp/entry/dataplex-explained
        - https://blog.g-gen.co.jp/entry/data-analysis-release-notes/202303
- Event-driven Architecture
    - Cloud Pub/Sub
        - https://blog.g-gen.co.jp/entry/understanding-loosely-coupled-architecture
        - https://blog.g-gen.co.jp/entry/pubsub-cloud-storage-import-topic
    - Eventarc
        - https://blog.g-gen.co.jp/entry/event-driven-architecture-with-cloud-run-jobs
- Data Security
    - Cloud DLP
        - https://blog.g-gen.co.jp/entry/data-loss-prevention-with-google-drive
- Storage
    - Cloud Storage
        - https://blog.g-gen.co.jp/entry/cloud-storage-explained
        - https://blog.g-gen.co.jp/entry/cloud-storage-versioning-lifecycle
        - https://blog.g-gen.co.jp/entry/fix-on-cloud-storage-charges
        - https://blog.g-gen.co.jp/entry/cloud-storage-managed-folders

# ログ

## 2025-07-05

- https://blog.g-gen.co.jp/entry/cloud-run-explained
    - Cloud Run は、knative ベースのコンテナ実行サービス
    - Cloud Run の実行基盤は、Gen1 は gVisor、Gen2 は microVM
    - Cloud Run には services, jobs, functions, worker pools の4つがあり、worker pools はプレビュー版
        - services: HTTP(S) リクエストベースのサーバー実行サービス、コンテナイメージ実行
        - jobs: 任意のタイミングで実行できるジョブ実行サービス、60分以上の実行時間や並列処理をサポート
        - functions: HTTP リクエスト・トリガーベースの2種類のイベント駆動関数実行サービス、ランタイムに制約あり
        - worker pools: Pub/Sub や Kafka などのメッセージキューと組み合わせた pull 型ワークロード実行サービス
    - Cloud Run のデフォルト自動スケーリングは 0 ~ 100、デフォルト上限は 1000、サポートへの上限拡大申請可能
    - Cloud Run が 0 にスケールインしたあとの起動はコールドスタートとなり、スケールイン下限を 1 以上にすることでウォームスタートが可能
    - Cloud Run は VPC 外に作成され、デフォルトでは VPC 内のリソースに Internal IP でアクセス不可、アクセスを有効化するにはサーバーレス VPC アクセスまたはDirect VPC Egress を使う
    - Cloud Run はリージョナルサービスであり、ゾーンを意識する必要はない
    - Cloud Run に他の Google Cloud サービスからアクセスするには、Cloud Run 起動元ロール（ `roles/run.invoker` ）または同等のカスタムロールが必要
    - Cloud Run には、リクエストベース課金モードとインスタンスベース課金モードがある
- https://blog.g-gen.co.jp/entry/cloud-functions-explained
    
    Cloud Run functions の実行基盤は、Gen1 は独自のサーバーレス実行環境、Gen2 は Cloud Run
    
    Cloud Run functions の実行時間制限は、Gen1 は9分、Gen2 HTTP ベースでは10分、Gen2 イベントトリガーベースでは60分
    
- https://blog.g-gen.co.jp/entry/cloud-functions-to-cloud-logging
    - Cloud Run functions では、標準出力が自動で Cloud Logging に記録される
    - Cloud Run functions でログにログレベルなどの属性を付与するには、JSON 構造化するか、Cloud Logging クライアントライブラリを使う
- https://blog.g-gen.co.jp/entry/how-to-test-pubsub-triggered-functions
    - Functions Framework
    - Pub/Sub Emulator
- https://blog.g-gen.co.jp/entry/understanding-loosely-coupled-architecture
    - Pub/Sub は、Amazon SQS、Amazon SNS、Amazon Kinesis Data Streams を組み合わせたようなサービス
    - Pub/Sub は、pull/push 両型をサポート
    - Pub/Sub は、producer/queue/consumer アーキテクチャ
    - 1つの Topic に対して1つの Subscriber を作れば、同じ処理を実行する Subscriber を自由にスケールできる
    - 1つの Topic に対して複数の Subscriber を作れば、異なる処理を実行する Subscriber を各々自由にスケールできる
- https://cloud.google.com/docs/get-started/aws-azure-gcp-service-comparison?hl=ja
- https://cloud.google.com/architecture?hl=ja
- Solution Design Pattern（https://www.gc-solution-design-pattern.jp/%E3%83%9B%E3%83%BC%E3%83%A0）

## 2025-07-04

- https://blog.g-gen.co.jp/entry/professional-cloud-architect
    - Sensitive Data Protection／DLP 繋がりで、BeyondCorp というサービスを知った、IT Admin 向けのサービスっぽい
    - GKE／オブザーバビリティと Grafana、Prometheus、PromQL などを知った
    - GKE／Google API へのアクセス（認証）と Workload Identity
    - Cloud SQL／ポイントインタイムリカバリ（PITR）機能を用いるには自動バックアップ、ポイントインタイムリカバリ両方の有効化が必要
    - Cloud Storage／Cloud Storage のパフォーマンス最適化に向けたブログ記事を発見
- https://cloud.google.com/sensitive-data-protection/docs/sensitive-data-protection-overview?hl=ja
    - 機密データの検出
        - 多様なデータソース（BigQuery、Cloud Storage、Datastore、etc.）を含む組織内のデータをスキャンし、個人識別情報（PII）、金融情報、医療情報などの機密データの所在を特定する
        - 事前定義された情報タイプ（InfoType）を利用でき、組織固有のカスタムデータパターンも定義可能
    - 機密データの検査
        - データのアップロード、転送、処理時にリアルタイムで機密データを検査できる
    - 機密データの匿名化
        - マスキング、トークン化、フォーマット保持暗号化（FPE）、日時シフト、バケット化など多様な匿名化手法を適用可能
        - 可逆的匿名化、条件付き匿名化など高度な機能も利用可能
    - リスク分析
        - 機密情報の漏洩（再識別）リスクを特定し可視化できる
    - Cloud Data Loss Prevention API
        - 機密データ保護をプログラムで利用できる。
- https://cloud.google.com/blog/ja/products/gcp/optimizing-your-cloud-storage-performance-google-cloud-performance-atlas
    - gsutil で parallel_composite_upload_threshold オプションを使って大きいローカルファイルの並列アップロードができるの知らなかった
    - gsutil で sliced_object_download_max_components オプションを使って逆に大きなファイルの並列ダウンロードができるみたい
    - S3 同様、ファイル命名（ディレクトリ構造）がアップロード速度に影響を与えることを知った、S3 のその仕様も思い出した
    - Cloud Storage のアップロード時、デフォルトでファイルパスに基づいてアップロード接続がバックエンドシャードに自動分散される、ファイルパスが似ていると同じシャードに誘導されるためパフォーマンスが低下する可能性がある

## 2025-07-03

- https://docs.google.com/forms/d/e/1FAIpQLSe55cAg8a3NzgV_QCJ2_F75NAyE44Z-XuVB6oPJXaWnI5UBIQ/viewscore?hl=ja&hl=ja&viewscore=AE0zAgDoTVZlY7RBxQ98DimQ5BB1qfu2emPm1iL4_YFtO8koRjp4NZevKfervcYrrPu_x6g
    - Cloud SQL／Recommender API の推奨事項
        - https://cloud.google.com/sql/docs/mysql/recommender-sql-overprovisioned?hl=ja#console
        - Recommender API を使ってオーバープロビジョニング削減の推奨事項を確認できる
    - Cloud SQL／インポート・エクスポート
        - サーバーレスエクスポート：大規模なデータの単発のエクスポートに適する
        - リードレプリカからのエクスポート：大量でないデータの頻繁なエクスポートに適する
        - 同時実行できるインポート・エクスポートは1つまで
        - エクスポート中もインスタンス編集、インポート、フェイルオーバーは可能
    - Cloud SQL／MySQL／slow_query_log
        - 指定された実行時間を超えるクエリをスロークエリとして自動でログ記録する機能
        - データベースフラグだけで簡単に有効化可能
    - Cloud SQL／インスタンスの停止によるコストカット
        - Cloud Run functions でインスタンスの開始・停止のための簡易な関数を実装し、Cloud Scheduler で時刻設定することで、特定の時間だけインスタンスを動かしておくことができる、というノウハウ
    - Cloud SQL／ポイントインタイムリカバリー（PITR）
        - 自動バックアップ + トランザクションログのアーカイブによる継続的バックアップ
        - 過去7日間の任意の時点（秒単位）に復旧可能
    - Cloud Storage／Storage Transfer Service
        - オンプレミス、AWS S3 から Google Cloud Storage への転送、
        - 単発・継続的転送
        - 10TB 未満のユースケース
    - Cloud Storage／Transfer Appliance
        - 大容量のストレージデバイス、デバイスにデータをアップロードし、Google Cloud の施設に返送し、そこから Cloud Storage バケットにアップロードされる
        - 単発転送
        - 10TB 以上のユースケース
    - Database Migration Service
        - 用途：オンプレミス、他クラウド、他の DB からの単発の移行
        - リフト＆シフト移行（本番システムをクラウド移行する際の最小ダウンタイム移行）
    - Datastream
        - 用途：リアルタイムデータレプリケーション、継続的なデータ同期、分析向けのデータ取り込み、イベント駆動
        - ユースケース：リアルタイム分析、異種データベース間の低遅延な同期、継続的な ETL パイプライン
    - Firebase／用途
        - リアルタイム機能（フォロワーへの即座の通知など）、モバイル特化のユースケース、ユーザー管理・認証の実装が容易
    - Firebase／Cloud Run functions for Firebase
        - イベント駆動、リソース集約的処理、サーバーレス、コスト効率がよい
    - Firestore／Native mode と Datastore mode
        - 共通点
            - NoSQL ドキュメントデータベース
            - 柔軟なスキーマ
            - ACID トランザクションサポート
            - 容量のオートスケーリング
            - 99.999% の可用性
            - グローバル分散（マルチリージョン）
        - 相違点
            - Native mode
                - モバイル・ウェブアプリケーション向け
                - リアルタイム機能
                - オフライン機能（自動同期）
                - App Engine 統合が限定的
            - Datastore mode
                - サーバーサイド向け
                - リアルタイム機能なし
                - オフライン機能なし
                - App Engine 統合
    - VPC／Dedicated Interconnect／ダイナミックルーティングモード
        - リージョナルモード（デフォルト）：他リージョンのルートを自動学習しない
        - グローバルモード：全てのリージョンのルートを動的に学習
        - Dedicated Interconnect はオンプレミスと近くのリージョンを繋ぐもので、リージョナルモードでは別リージョンのルートを学習できない

## 2025-07-02

- https://docs.google.com/forms/d/e/1FAIpQLSc_67KaPnNwQrLZ7kuhw-aubz7gMAwY6DQwRJYcW0qlG-iajA/viewscore?hl=ja&hl=ja&viewscore=AE0zAgALxwqcLkVf1nubM8Xm0kF9Plhq8HFTbq1r0qaBphJgU4ECF7HbXioXL3BLMeFlwdw
    - Cloud Build／ステップ間のデータ共有・受け渡し／Cloud Build 内にはステップ間で共有される永続ファイルシステムがある。したがって、ステップに結果をファイルに保存し次のステップで使うことができる。環境変数はステップを実行するコンテナ内のローカルデータであり次のステップに引き継がれないためデータの受け渡しには使えない
    - Cloud Profiler／関数ごとのレイテンシ、レイテンシの履歴情報などを確認できる
    - Cloud Run／セッションタイムアウト／Cloud Run は最大 60 分のセッションと gRPC をサポートし、ゼロにスケーリングして、オペレーター不要です。
    - Cloud Run／サーバーレス VPC アクセス／Cloud Run のコンテナインスタンスは VPC 外で実行されるが、Cloud SQL や Memorystore などの VPC 内リソースにプライベートネットワーク経由でアクセスしたい場合には VPC に接続する必要がある、その場合 VPC に「サーバーレス VPC アクセス」あるいは「Direct VPC Egress」を構成することで実現できる
        - https://blog.g-gen.co.jp/entry/tips-for-serverless-vpc-access-maintenance
    - Cloud Run／Direct VPC Egress
        - https://blog.g-gen.co.jp/entry/modifying-serverless-vpc-access-for-direct-vpc-egress
        - Cloud Run 第2世代のもとで Direct VPC Egress を使用するとコールドスタート時間が長くなる可能性がある
        - Cloud Run の最大コンテナインスタンス数の4倍の IP を Direct VPC Egress 用に割り当てることが推奨されており、IP が枯渇していると使用できない
        - というようなデメリットが許容できる場合は、Direct VPC Egress よりもコスト面で優れている
    - Cloud Run functions／Cloud Storage トリガー／ファイル名でフィルタすることは不可能で、バケットに加えたすべての変更が送信されます。
    - Cloud Run functions／Pub/Sub トリガー／新しいメッセージが到着すると直ちに起動する（Push）。費用は新しいメッセージがトピックに到着した場合のみ発生
        - https://blog.g-gen.co.jp/entry/slack-slash-commands-with-cloud-run-functions
        - https://blog.g-gen.co.jp/entry/event-driven-for-bigQuery-data-transfer-service
        - https://blog.g-gen.co.jp/entry/pubsub-subscription-for-cloud-storage
    - Cloud Spanner／Cloud SQL との棲み分け／Cloud SQL は複数リージョンでの高可用性を実現できないため、グローバルの整合性と可用性を実現するには Cloud Spanner を利用できる
        - https://cloud.google.com/spanner?hl=ja
    - Cloud Storage／署名付き URL／Cloud Storage にアクセスするユーザーに Google アカウントを要求するのではなく、アプリケーション固有のロジックでアクセス制御したい場合があります。この場合は、ユーザーに署名付き URL を提供することで期間限定で目的のリソースに対して読み取り、書き込み、削除ができるアクセス権をユーザーに付与できます。
    - Cloud Storage／バケットロック／バケット内のオブジェクトの保持期間を制御したり、その保持ポリシーをロックしてポリシーの変更・削除を防ぐことができる
        - https://cloud.google.com/storage/docs/bucket-lock?hl=ja
    - Cloud Storage／ストレージクラス／Standard、Nearline、Coldline、Archive の順で価格が下がっていく、ストレージ料金が下がる代わりにオペレーション料金・検索料金は上がる、クラスを自動変更する Autoclass という機能もある
        - https://cloud.google.com/storage/docs/storage-classes?hl=ja
    - Compute Engine／External IP のない GCE インスタンスから GCS API （Public API）にアクセスするには、限定公開の Google アクセスを使えば、External IP がなくてもサブネット内のインスタンスから Public API エンドポイントと通信できる
    - Container Analysis／CVE のイメージスキャンが可能
    - Eventarc／は柔軟なフィルタをサポートし、ファイル名パターンに基づいてトリガーを作成できます。
        - https://blog.g-gen.co.jp/entry/notify-using-eventarc-for-cloudrun
    - Firestore／ユースケース／ショッピングカートのような小規模な構造化データに最適
    - GKE／Cloud Service Mesh／User-Agent に基づくトラフィック分割なども可能
        - https://cloud.google.com/service-mesh/docs/overview?hl=ja
    - GKE／Cloud Service Mesh／Cloud Service Mesh トラフィック管理は、A/B テストの転送ルールを実装する場合に便利なツールです。
        - https://cloud.google.com/service-mesh/docs/service-routing/advanced-traffic-management?hl=ja
    - GKE／GatewayClass／Cloud Load Balancing にあるようなロードバランサーの種類的なものとして GatewayClass が存在する
        - https://g-gen.co.jp/useful/google-service/20716/
    - GKE／GKE networking
        - https://cloud.google.com/kubernetes-engine/docs/concepts/service-networking?hl=ja
    - GKE／Pod、Service、Deployment／Pod はマイクロサービスの単一インスタンス、Service はクラスタ内部に DNS エントリを持っており他のマイクロサービスがそれを使って Service のターゲットの Deployment の各 Pod をアドレス指定できる
    - GKE／Secret の取得／Secret Manager にシークレットを格納し、Secret Manager からシークレットを読み取る SA を作成し、Workload Identity により Google SA として k8s SA を認証することで、安全にシークレットを取得できる
    - GKE／Workload Identity／認証情報変数を渡すことなく Google Cloud サービスを利用する場合に最善の方法です。
    - GKE／オートスケーラー
        - https://tech.quickguard.jp/posts/gke-autoscale-overview/
    - Memorystore／ユースケース／Redis 互換インメモリストア、セッション情報保存のためのソリューションとして標準的
    - OAuth 2.0／各種認証フローを把握しておくべき
        - https://developers.google.com/identity/protocols/oauth2?hl=ja#scenarios
- https://docs.google.com/forms/d/e/1FAIpQLSd4j4bcgbYenBRFIL6Kb0cvXp13qCQ-z6JzowgDxRaPITn56g/viewscore?hl=ja&hl=ja&viewscore=AE0zAgBULR9mfusZYEVUFL9p5zlxh81wiHt8VRwONn5lfDjcQmu3epYslLiYafQyntX-mJk
    - AI／AutoML／AutoML は他の類似データに基づく転移学習を使用するため、適切です。高精度のモデルを構築するには BigQuery ML は多くのデータを必要とします。
    - AI／AutoML Vision／画像から情報を抽出する既製のモデルはありません。
    - AI／Document AI／画像を読み込んでテキスト情報を抽出する事前パッケージソリューションが提供されます。
        - https://cloud.google.com/document-ai?hl=ja
    - AI／Cloud Natural Language／画像から情報を抽出する既製のモデルはありません。非構造化テキストの分析情報を引き出す際に使用されます。
    - BigQuery／マテリアライズドビュー／パフォーマンスを向上させるためにクエリの結果を定期的にキャッシュ保存します。マテリアライズドビューは、頻繁にクエリされる小さなデータセットに適しています。基盤となるテーブルデータが変更されると、影響を受ける部分をマテリアライズドビューが無効化して再度読み込みます。
    - BigQuery／コネクテッド シートにより、Google スプレッドシートを通じて BigQuery データを簡単に共有できます。
        - https://cloud.google.com/bigquery/docs/connected-sheets?hl=ja
    - Bigtable／ホットスポットを回避するため、単調増加の設計を避ける必要がある
        - https://cloud.google.com/bigtable/docs/schema-design?hl=ja
    - Bigtable／Key Visualizer／テーブルに関する視覚的なレポートが生成されます。このレポートは、アクセスする行キーに基づき使用を詳細に説明し、どのように Bigtable が動作しているかを示し、パフォーマンス問題のトラブルシューティングに役立ちます。
        - https://cloud.google.com/bigtable/docs/keyvis-overview?hl=ja
    - Cloud DLP（Data Loss Prevention）／データ プライバシーの保護に役立つテキストと画像の削除、マスク、トークン化、変換の推奨手法です。
    - Cloud Spanner／インターリーブをサポートしており、同じスプリットにデータが保存されるようにします。これにより、強いデータ局所性関係が必要なときのパフォーマンスが向上します。
        - https://cloud.google.com/spanner/docs/schema-and-data-model?hl=ja
        - https://cloud.google.com/spanner/docs/migrating-postgres-spanner?hl=ja
    - Cloud SQL／Cloud SQL Auth Proxy
    - Cloud SQL／マネージド MySQL、PostgreSQL、SQL Server データベースを提供し、管理作業を軽減します。
    - Dataflow／ストリーミング データのための推奨データ処理プロダクトです。
        - https://cloud.google.com/dataflow/docs/concepts/streaming-pipelines?hl=ja
    - Dataflow／ホッピング ウィンドウを使用して移動平均を計算できます。
    - Dataproc／Apache Spark、Presto、Apache Flink、Apache Hadoop など、オープンソースの分散処理プラットフォームを Google Cloud でホストするためのフルマネージド サービスです。
        - https://cloud.google.com/dataproc/docs/concepts/configuring-clusters/scaling-clusters?hl=ja
    - Network／Dedicated Interconnect、Partner Interconnect／定期的に大量のデータが転送される場合、専用のハイブリッド ネットワーク接続が推奨されます。
    - Network／Transfer Appliance／数百テラバイトのデータの転送には Transfer Appliance の使用が推奨されます。

## 2025-07-01

- https://blog.g-gen.co.jp/entry/professional-cloud-network-engineer
    - バブアンドスポーク型トポロジー（スター型）
        - カスタムルート
        - 推移的ピアリング
        - フルメッシュを避けるための Cloud VPN
    - Cloud Router
        - リージョンリソース
        - VPC に紐付く
        - ASN を持つ
        - デフォルトで全てのサブネットへの経路を対向ルーターに広報する
    - 新しく知った概念
        - Inbound Policy
        - Forwarding Zone
        - DNS Peering
    - Cloud Armor の検知ログは Cloud Load Balancing のアクセスログに出る
- https://blog.g-gen.co.jp/entry/vpc-explained-basics
- https://blog.g-gen.co.jp/entry/vpc-explained-advanced
    - VPC 内のサブネットはリージョンが異なってもデフォルトで互いに通信できる、これはサブネット作成時に自動で全てのリージョンで全てのサブネットに対するルートが作成されるため
- https://blog.g-gen.co.jp/entry/cloud-firewall-explained
- https://blog.g-gen.co.jp/entry/vpn-base
- https://blog.g-gen.co.jp/entry/cross-cloud-interconnect-explained

## 2025-06-30

- https://blog.g-gen.co.jp/entry/associate-cloud-engineer
- https://blog.g-gen.co.jp/entry/professional-cloud-architect
- https://blog.g-gen.co.jp/entry/professional-cloud-developer#%E7%9B%A3%E8%A6%96%E3%82%AA%E3%83%96%E3%82%B6%E3%83%BC%E3%83%90%E3%83%93%E3%83%AA%E3%83%86%E3%82%A3

## 2025-06-29

- https://blog.g-gen.co.jp/entry/private-google-access-explained
    - 限定公開の Google アクセスのエンドポイントへのアクセス
        - Private Service Connect 同様、Cloud DNS で CNANE レコードの利用によってデフォルトドメインへのリクエストを、private/restricted のドメインにリダイレクトすることで、接続可能
- https://blog.g-gen.co.jp/entry/google-api-private-service-connect-explained
    - 専用エンドポイントへのアクセス
        - クライアント側でエンドポイントを明示的に指定する
        - サービス提供側で Cloud DNS で *.googleapis.com へのドメイン解決 IP を専用エンドポイントの IP に設定することで、自動的にアクセスさせる
- https://blog.g-gen.co.jp/entry/managed-service-with-private-service-connect
    - サービス公開方法
        - インターネットへの公開
            - 特定少数に公開する目的に対してセキュリティ上の懸念あり
        - VPC 同士の接続
            - VPC Peering
            - Cloud VPN
            - 全ての VPC の IP Range が重複しない必要がある
        - Private Service Connect
- https://blog.g-gen.co.jp/entry/compute-engine-basic-explained
    - ストレージ
        - Persistent Disk
            - 不揮発性
            - タイプ: Standard、Balanced、Performance、Extreme
        - Hyperdisk
            - 不揮発性
            - タイプ: Hyperdisk Balanced、Hyperdisk Balanced High Availability、Hyperdisk ML (for DB)、Hyperdisk Throughput (for Hadoop, Kafka)
        - Local SSD
            - 揮発性、ただし VM 停止時に Persistent Disk に退避することで復帰可能
            - 高速 I/O、低レイテンシー
        - 可用性
            - 【Persistent Disk】別リージョンへの非同期転送による BCP 対策が可能（Persistent Disk 非同期レプリケーション）
            - 【Persistent Disk、Hyperdisk Balanced High Availability】ゾーン間の同期レプリケーションによるゾーン障害対策が可能
        - 気密性
            - GCP の保存データは全て、デフォルトで透過的に暗号化されている
            - デフォルトの透過的暗号化ではマネージドの暗号鍵が利用される
            - 組織のセキュリティポリシーに応じてユーザー管理の暗号鍵も利用できる
                - Cloud KMS
                    - CMEK: Customer−Managed Encryption Key: 鍵の管理は KMS 担当
                    - CSEK: Customer-Supplied Encryption Keys: 鍵の管理もユーザー担当
    - バックアップ
        - スナップショットにはスケジュール機能がある
        - バックアップにはスケジュール機能がない（Backup for GKE 同様、Cloud Scheduler・Cloud Run functions を使って実装できる）

## 2025-06-28

- https://blog.g-gen.co.jp/entry/external-https-load-balancing-explained
    - いままで、ネットワークとかロードバランサー系の料金、従量課金のコストの試算て、自分の頭の中でやってこなかった
    - 計算が苦手なのもあるが、リクエスト、レスポンスの数とサービス規模の関係について、なんのベース知識も持ってなかった
    - ここのやり取りの容量の相場が頭にないから、規模に応じた料金をイメージができない、これはサービス開発者として知識不足だ
    - Regional のほうは CDN や Armor が現状使えないのは驚きだった、本当にグローバル前提なんだな
    - PoP = Point of Presence
    - AWS ALB の登場人物は、LB、Listener、Listener Rule、Target group、で紐づけるバックエンド
    - GCP ALB では、ALB、Forwarding Rule、Target Proxy、URL map、backend service
- https://blog.g-gen.co.jp/entry/gke-explained
    - Operation Mode: Autopilot, Standard
    - Availability Mode: Single-zone, Multi-zone, Regional
    - Network Mode: VPC Native, Route Based
    - Upgrading Strategy: Rapid, Regular, Stable
    - EKS との違い
        - EKS には Kubernetes の自動アップグレードがない
        - EKS も GKE もアップグレードスケジュールはどっこいどっこい（GKE にはアップグレード追随速度にオプションがある）
        - GKE で使われる HTTP(S) Load Balancer は Pre-warming が不要、EKS で使われる ALB はサポートへの申請による Pre-warming が必要
        - GKE では Cloud Monitoring との統合がデフォルト、EKS ではデフォルトはなく CloudWatch OR 3rd Party Tool との統合整備が必要
        - GKE の方が EKS よりも料金が安くなることが多い
    - https://blog.g-gen.co.jp/entry/kubernetes-explained
        - コントロールプレーン（マスターノード）、ノード（ワーカーノード）
        - コントロールプレーン > kube-scheduler, kube-controller-manager, kube-apiserver, etcd, kube-dns
        - ノード > pod, kubelet, kube-proxy
        - API
            - Workload API ↔ Pod, ReplicaSet, Deployment
            - Service API ↔ Service
            - Config API ↔ Secret, ConfigMap
            - Cluster API ↔ PersistentVolume, Node, Namespace
            - Metadata API
    - https://blog.g-gen.co.jp/entry/gke-workload-identity
        - ノードに紐づいた SA を利用する
            - 最小権限の法則に反する
        - SA キーを Kubernetes Secret として GKE Cluster に登録する
            - 最小権限の法則に準ずるが、SA キー管理が煩雑化する
        - Workload Identity Federation （旧）
            - 最小権限の法則に準じ、SA キー管理が不要になる
            - IAM SA （プリンシパル）を Kubernetes SA に紐づけることで実現
            - = GKE SA が IAM SA の権限を借用する
            - = GKE SA が IAM SA になりすます（Impersonate）
        - Workload Identity Federation （新）
            - 最小権限の法則に準じ、SA キー管理が不要になり、IAM SA の作成が不要になる
            - GKE SA をプリンシパルとして IAM ロールを紐づけられるようになった
            - → VPC Service Control でサービス境界を設定する場合、そのルールのアクセス許可対象に GKE SA は使えない
            - → その場合は旧式の権限借用パターンを使う
    - https://cloud.google.com/kubernetes-engine/docs/how-to/network-policy?hl=ja
    - https://cloud.google.com/kubernetes-engine/docs/how-to/ingress-multi-ssl?hl=ja
    - https://cloud.google.com/kubernetes-engine/docs/concepts/release-channels?hl=ja
    - https://cloud.google.com/kubernetes-engine/docs/add-on/backup-for-gke/concepts/backup-for-gke?hl=ja
        - 構成要素：Backup for GKE Service（Backup、Restore の操作のためのインターフェース）、Backup for GKE Agent（バックアップ、復元の操作の実行）
        - バックアップの冗長性：
            - アーティファクトは選択したリージョン内の複数ゾーンに複製される
            - サービスは各リージョンの少なくとも3つのゾーンに複製される
        - バックアップの対象外：
            - ノード構成、ノードプール、初期クラスタサイズ、有効化された機能などのクラスタ構成情報
            - バックアップが参照するコンテナイメージ
            - クラスタ外のサービス構成情報・状態（Cloud SQL、External Load Balancer、etc.）
            - Persistent Disk ボリューム以外のボリューム（Filestore NFS、Google Cloud NetApp Volume、etc.）
            - ただし、Filestore は Backup for GKE との連携をセットアップすることでバックアップ、復元、再接続が可能
- https://blog.g-gen.co.jp/entry/committed-use-discounts-explained
    - 確約利用割引 = Committed Use Discounts = CUD
    - CUD とキャパシティの予約は別、CUD を買っていてもキャパシティ不足が生じる可能性があり、確実な利用にはゾーンリソースの予約が必要
    - リソースベース CUD
        - プロジェクト単位、リージョン単位
        - Compute Engine を使うサービスにのみ適用される
    - フレキシブル CUD
        - 請求先アカウント単位（リージョン横断）
        - 対象マシンタイプのみに適用される
    - AWS Reserved Instance・Savings Plan には前払いオプションがあり、前払い額が大きいほど割引額が大きい、GCP CUD にはそのような仕組みはない
    - AWS Savings Plan はインスタンスファミリー（GCP のマシンシリーズ）横断で適用されるが GCP CUD は違う
    - AWS Reserved Instance は Marketplace で売却できるが、GCP CUD にはそのような仕組みはない
- https://blog.g-gen.co.jp/entry/filestore-explained
    - NFSv3 のファイルストレージ
    - NFSv3 では通信の暗号化はされない
    - Google Cloud 外から GFS をマウントする場合、GFS は Public IP を持たず、NFSv3 の通信は暗号化されないため、Cloud VPN（IPSec）や Cloud Interconnect でプライベート接続を確立する必要がある
    - 課金
        - ディスク容量: ディスク容量 x インスタンス時間
        - バックアップ: GiB あたりの保管料
        - ネットワーク: GFS というよりも Google Cloud ネットワークの課金体系に該当する
    - サービスティア
        - 基本 HDD
        - 基本 SSD
        - ゾーンサービスティア（低容量／高容量）
        - リージョンサービスティア（低容量／高容量）
        - 基本ティアは縮小不可、ゾーン・リージョンティアは縮小可
        - ゾーン／リージョンの差は可用性
    - バックアップ
        - 自動取得機能はないが、Cloud Scheduler／Cloud Functions／Filestore API により実現可能

## 2025-06-27

- https://blog.g-gen.co.jp/entry/opsagent-windows
- https://blog.g-gen.co.jp/entry/cloud-audit-logs-explained
- https://blog.g-gen.co.jp/entry/cloud-armor-explained

## 2025-06-26

- https://cloud.google.com/endpoints/docs/openapi/architecture-overview?hl=ja
    - Amazon API Gateway の Google 版
    - ESP、ESPv2 がある（ESP = Extensible Service Proxy）
    - ESP は NGINX ベース、ESPv2 は Envoy ベース
- https://blog.g-gen.co.jp/entry/iam-explained
    - IAM の概念と仕組みは GCP / AWS で割と差分がある
        - AWS
            - AWS では IAM ポリシーが権限の集合体で、IAM ユーザーが人間としての主体（プリンシパル）、IAM ロールがプログラムとしての主体（プリンシパル）
            - AWS では IAM ユーザーも IAM ロールも AWS アカウント（テナント）内に含まれるリソース
            - AWS では権限をまとめたロールをプリンシパル側に紐づける
        - GCP
            - GCP では IAM ロールが権限の集合体で、リソースごとに1つずつ IAM ポリシーがあり IAM ポリシーがバインディングを複数もつ、という構造になっている
            - バインディングはプリンシパルに付与するロールとその条件をもつオブジェクトである
            - GCP では IAM ユーザーはすなわち Google アカウント（OR Google Workspace アカウント）であり、Google Cloud テナントの外にある
            - ただし、サービスアカウントは Google Cloud プロジェクト内のリソース
            - GCP では権限をまとめたロールをリソース側（正式にはリソースがもつポリシー）に紐づける
    - GCP 外から GCP サービスにアクセスする
        - Workforce Identity は人間向け、Workload Identity はプログラム向け
        - Workload Identity Pool Provider、Workload Identity Pool をつくり、AWS STS で発行したトークンを Google STS に渡し、Pool と照合して認証できたら、サービスアカウントになりすますトークンが返される、それを使って Google Cloud API を認証でき、予め作成しておいたサービスアカウントの権限で操作を実行できる
        - https://blog.g-gen.co.jp/entry/using-workload-identity-federation-with-aws
        - https://blog.g-gen.co.jp/entry/aws-lambda-to-cloud-storage
- https://blog.g-gen.co.jp/entry/cloud-logging-explained
    - シンク
    - シンクからのログルーティング

## 2025-06-25

- https://blog.g-gen.co.jp/entry/vpc-service-controls-explained
    - Google Cloud API へのアクセス
    - プロジェクト、IPなどによる境界設定
    - ドライラン、WAF の COUNT/BLOCK
    - アクセスポリシー、管理の委譲
    - 内向き、外向き
- https://cloud.google.com/binary-authorization/docs/key-concepts?hl=ja
    - デプロイに際して必要なプロセスが実行されたことをイメージに対して署名する
    - 秘密鍵、暗号鍵
- https://cloud.google.com/binary-authorization/docs/cloud-build?hl=ja
    - Binary Authorization は署名を検証し不正なデプロイを防ぐ仕組み
    - イメージに署名するのは KMS

## 2025-06-24

- https://blog.g-gen.co.jp/entry/login-your-vm-with-iap
    - AWS IAM Identity Center が近い
- https://blog.g-gen.co.jp/entry/professional-cloud-developer
    - Kubernetes、API プラットフォーム構築、ジョブ自動化、あたりが弱点
- https://blog.g-gen.co.jp/entry/network-intelligence-center-explained
    - ネットワーク接続テスト
    - ネットワークトポロジー可視化
    - ファイアウォールインサイト、ヒットしないルール、過剰に緩いルールの検出
    - ネットワークアナライザ
        - ネットワーク構成ミス、セキュリティ問題の検出
        - VPC Flow Logs、Flow Analyzer

## 2025-06-23

- https://blog.g-gen.co.jp/entry/associate-cloud-engineer
- https://blog.g-gen.co.jp/entry/professional-cloud-architect
- https://docs.google.com/forms/d/e/1FAIpQLSc7bkUHpDbFShBI5xE4u8OO2vl99DrP0htnswa-la9DQynToA/viewscore?hl=ja&hl=ja&viewscore=AE0zAgDjAfImz-UxIMSA3H72m2dne8ExXIja4soxl6IvCJcJ5SFnQlLw-crt24Eb28c7LVE
    - 特殊なネットワーク接続（VPN、Partner Interconnect、Dedicated Interconnect、Transfer Appliance）系は AWS のときと同様、経験値がないので苦手、ドキュメント読み込みが必要
        - https://cloud.google.com/dns/docs/tutorials/create-domain-tutorial?hl=ja
        - https://cloud.google.com/vpc/docs/create-modify-vpc-networks?hl=ja#expand-subnet
        - https://cloud.google.com/transfer-appliance/docs/4.0/overview?hl=ja
    - GKE 回りは ECS で触れない概念・仕組みがありそう、ドキュメント読み込みと Skills Boost での練習が必要、GKE Autopilot とか知らない
        - https://cloud.google.com/kubernetes-engine/docs/concepts/autopilot-overview?hl=ja
    - Skills Boost で使ってきた Google Cloud 公式の Terraform モジュールは「Google Cloud Terraform ブループリントモジュール」と呼ぶらしい
        - https://cloud.google.com/docs/terraform/blueprints/terraform-blueprints?hl=ja
    - リソース割り当ての管理（課金管理とか）も経験値が少ないのでドキュメント読み込みが必要
        - https://cloud.google.com/compute/resource-usage?hl=ja
    - Cloud Audit Logs は知らなかった
        - https://cloud.google.com/bigquery/docs/troubleshoot-quotas?hl=ja
- https://docs.google.com/forms/d/e/1FAIpQLScpVCxsKSrqMBmqJ4fiYrJfCSlMhJVIFaW_v3MD4xEd6NW0Bw/viewscore?hl=ja&hl=ja&viewscore=AE0zAgBDQ917j_NCsflV7-vhGYKVWnL9CDZZf0XqXjoS-j2ObD7ZB3llbEgNCRMgfkneh1Q
    - Cloud Interconnect
        - Partner/Dedicated の違い／Dedicated ではハードウェア購入、10GB のインターフェース入手が必要
        - https://cloud.google.com/blog/products/networking/google-cloud-network-connectivity-options-explained?hl=en
        - https://cloud.google.com/network-connectivity/docs/carrier-peering?hl=ja#considerations
        - https://cloud.google.com/network-connectivity/docs/interconnect/concepts/partner-overview?hl=ja
        - https://cloud.google.com/network-connectivity/docs/interconnect/concepts/dedicated-overview?hl=ja#before_you_use
    - VPC Service Controls
        - 知らなかった、Google Cloud サービスからのデータ引き出しリスクを軽減できる、どういう仕組みなんだろう？
        - https://cloud.google.com/vpc-service-controls/docs/overview?hl=ja
        - https://cloud.google.com/storage/docs/access-control/lists?hl=ja
    - VPC Service Controls と Cloud Shell
        - https://cloud.google.com/vpc-service-controls/docs/supported-products?hl=ja#shell
            - VPC Service Controls は、Cloud Shell をサービス境界外として扱い、VPC Service Controls が保護するデータへのアクセスを拒否します。ただし、サービス境界のアクセスレベル要件を満たすデバイスが Cloud Shell を起動した場合、VPC Service Controls は Cloud Shell にアクセスできます。
    - Identity Aware Proxy (IAP)
        - Google Cloud 外部の HTTP ベースアプリケーションへのアクセスを管理できる
        - https://cloud.google.com/iap/docs/cloud-iap-for-on-prem-apps-overview?hl=ja
    - 監査ログのレポート作成
        - ここでいう監査ログ、使用状況レポートというものの詳細がよく分からない、試験前にやはり4つのケーススタディの内容は把握しておいたほうが良さそう
        - https://cloud.google.com/learn/certification/guides/professional-cloud-architect/?hl=ja
        - https://cloud.google.com/security/compliance/soc-2?hl=ja
        - https://cloud.google.com/bigquery/docs/cached-results?hl=ja#how_cached_results_are_stored
    - アーキテクチャセンター
        - https://cloud.google.com/architecture?hl=ja
        - 読み込んでおいたほうが良さそうなのだがどこまで読めるかなぁ
    - Google SRE Books
        - https://sre.google/books/
        - これも読み込んだほうがいい
        - SLO をどう策定するかということが自分は分かってない
    - Sensitive Data Protection > Cloud Data Loss Protection API (DLP API)
        - https://cloud.google.com/sensitive-data-protection/docs/deidentify-sensitive-data?hl=ja
        - データの匿名化に関するサービス
        - これはもともと Cloud DLP として独立していたが、現在は Sensitive Data Protection（機密データ保護サービス）の一部になっている
    - AutoML
        - https://cloud.google.com/automl?hl=ja
        - 知識・経験が薄い層向けの機械学習モデル構築サービス、というイメージ
    - Google Cloud のネットワークセキュリティ
        - https://cloud.google.com/vpc/docs/add-remove-network-tags?hl=ja
        - ネットワークタグ、という概念
        - 一般的には Google Cloud の方がシンプル、AWS の方が複雑で細やかな設定が可能でエンタープライズ対応、というイメージみたい
        
        [gcp_aws_network_comparison.pdf](Google%20Cloud%20Bootcamp%201f4db4565867804a8889da9f4ad398ce/gcp_aws_network_comparison.pdf)
        
    - データベースのパフォーマンスについて
        - ディスク容量も速度面に影響しあることを知った

## 2025-06-22

- Cloud Architect
    - Organization、IAM
    - Cloud Monitoring、Cloud Logging
    - Network Intelligence Center、Sensitive Data Protection
    - VPC
    - Compute Engine
    - Kubernetes Engine
    - Cloud Run、Cloud Run functions、App Engine
    - Cloud SQL
    - CI/CD
    - Cloud Storage
- Cloud Developer
    - Organization、IAM
    - Compute Engine
    - Kubernetes Engine
    - Cloud Run、Cloud Run functions、App Engine
    - Cloud Storage
    - Cloud SQL
    - Cloud Firestore
    - Cloud Pub/Sub
    - Cloud Monitoring、Cloud Trace、Cloud Profiler
    - Cloud Endpoints
    - Cloud Workflows、Cloud Composer
    - Cloud Build
    - Apigee、Apigee Analytics
- Data Engineer
    - Organization、IAM
    - Cloud Monitoring
    - Cloud Dataflow （Managed Apache Beam）
    - Cloud Pub/Sub
    - Cloud Composer、Cloud Scheduler
    - Cloud Dataproc （Managed Hadoop/Spark）
    - Cloud Dataplex
    - BigQuery
    - BigTable
    - AI/ML サービスの分類、使い分け
    - Cloud Sensitive Data Protection
- Security Engineer
    - 責任共有モデルの理解
    - Organization、IAM、Directory Sync
    - VPC、VPC Flow Logs、VPC Peering、Shared VPC、Packet Mirroring、NAT、VPC Service Controls
    - Security Command Center、Network Intelligence Center、Secret Manager
    - Cloud Interconnect、Cloud VPN
    - Cloud KMS
    - Cloud DLP
    - Cloud Armor
    - Cloud Load Balancing
- Network Engineer
    - VPC
    - Packet Mirroring
    - Cloud Router
    - Cloud NAT
    - Cloud Load Balancing
    - VPC Service Controls
    - Dedicated / Partner Interconnect
    - Cloud VPN
    - Cloud DNS
    - Cloud Armor
    - Network Intelligence Center
- Database Engineer
    - Compute Engine
    - Cloud SQL
    - Cloud Spanner
    - Cloud KMS
    - BigTable
    - Firestore
    - BMS （Bare Metal Solution）
    - DMS （Data Migration Service）
    - Datastream
- DevOps Engineer
    - https://www.amazon.co.jp/SRE-%E3%82%B5%E3%82%A4%E3%83%88%E3%83%AA%E3%83%A9%E3%82%A4%E3%82%A2%E3%83%93%E3%83%AA%E3%83%86%E3%82%A3%E3%82%A8%E3%83%B3%E3%82%B8%E3%83%8B%E3%82%A2%E3%83%AA%E3%83%B3%E3%82%B0-%E2%80%95Google%E3%81%AE%E4%BF%A1%E9%A0%BC%E6%80%A7%E3%82%92%E6%94%AF%E3%81%88%E3%82%8B%E3%82%A8%E3%83%B3%E3%82%B8%E3%83%8B%E3%82%A2%E3%83%AA%E3%83%B3%E3%82%B0%E3%83%81%E3%83%BC%E3%83%A0-%E6%BE%A4%E7%94%B0-%E6%AD%A6%E7%94%B7/dp/4873117917
    - Compute Engine
    - Kubernetes Engine
    - Cloud Run
    - IAM
    - OpenTelemetry、Cloud Monitoring、Cloud Logging、Cloud Error Reporting、Cloud Trace、Cloud Profiler
    - Cloud Artifact Registry、Cloud Build、Spinnaker、Cloud Deploy
- Machine Learning Engineer
    - 機械学習、深層学習に関わる概念、分類の理解
    - Vertex AI
        - Vertex AI Training
        - Vertex AI Model Registry
        - Vertex AI Endpoints
        - Vertex AI Batch Prediction
        - Vertex Explainable AI
        - Vertex ML Metadata
    - BigQuery ML
    - Vision AI、Video AI、Translation AI、Natural Language AI、Speech-to-Text、Text-to-Speech
    - Dataflow、Dataproc、Dataplex、Pub/Sub、Composer、Sensitive Data Protection

## 2025-05-23

今日以降の学習パス

- 軸は引き続き Professional Cloud Architect
- まずは Terraform 使えるようにしたい
- データエンジニア側は仕事に活きるので適宜挟みたい

## 2025-05-19

- gcloud、結構何でもできる、便利だなぁ
- 使ったコマンド群
    - `gcloud auth list`
    - `gcloud config list`
    - `gcloud config get <target>`
    - `gcloud config set compute/region <region>`
    - `gcloud config set compute/zone <zone>`
    - `gcloud compute firewall-rules list`
    - `gcloud compute instances create <name> --machine-type <machine_type> --zone <zone>`
    - `gcloud compute project-info describe --project <project>`
    - `gcloud compute ssh <name> --zone <zone>`

## 2025-05-15

- Preemptible VM と Spot VM
    - Spot VM の方が後発
    - Preemptible VM にあった最長使用時間制限などが取り払われている
- ライブマイグレーション
    - **仕組み**: VMをほぼ停止せずに、実行状態のまま別のホストへ移行する技術です。メモリコピー後、一瞬（約0.5秒）停止し差分を転送し、移行先で再開します。ネットワークのパケットロスやTCP接続切れは起きません。
    - **他のクラウドに対する独自性**: VMを動かしたままメンテナンスを行うTransparent Maintenanceを運用しています。Heartbleedバグの際も再起動なしでした。他社と比較して停止時間が短く、パケットロスがない点が特徴です。
    - **メリット**: 計画/非計画メンテナンスやハード障害時もVMを停止せず移行します。ユーザーはメンテナンスによる再起動や停止を気にせず、常に最新のインフラ上でVMを運用できます。
- default ではなくカスタムで VPC を作る場合の理由
    - 細かいカスタマイズが必要な場合
    - VPC 間での接続時の IP 衝突などを防ぐために手動設定が必要となる場合など