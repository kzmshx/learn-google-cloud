# ケーススタディ: Helicopter Racing League

## 会社概要

Helicopter Racing League（HRL）は、ヘリコプター レースを主催しているグローバルなスポーツ リーグです。HRL は毎年世界選手権を開催しています。複数の地域リーグの大会があり、各チームは世界選手権への出場権を競います。HRL では、レースを世界中にストリーミングする有料サービスを提供しています。その際、各レースにおけるライブでのテレメトリーと予測を行っています。

## ソリューションのコンセプト

HRL では、既存サービスを新しいプラットフォームに移行して AI および ML のマネージド サービスの使用を拡大し、レースの予測に役立てたいと考えています。また、特に新興国でこのスポーツに関心を持つ新しいファンが増えており、リアルタイムと録画の両方のコンテンツについて、ユーザーの居住地により近い場所でサービスを提供したいと考えています。

## 既存の技術的環境

HRL はクラウド ファーストを掲げる上場企業で、中心となるミッション クリティカルなアプリケーションは、同社が現在利用しているパブリック クラウド プロバイダで実行されています。動画の録画と編集はレース場で行われ、必要に応じてクラウドでコンテンツのエンコードやコード変換が行われます。また、トラックに積まれたモバイル データセンターにより、エンタープライズ クラスの接続とローカル コンピューティングが提供されています。レースの予測サービスは、既存のパブリック クラウド プロバイダのみでホストされています。

現在の技術的環境は次のとおりです：

- 既存のコンテンツは、既存のパブリック クラウド プロバイダ上のオブジェクト ストレージ サービスに保存されている
- 動画のエンコードとコード変換は、各ジョブ用に作成された VM で実行されている
- レースの予測は、既存のパブリック クラウド プロバイダ内の VM で実行される TensorFlow を使用して処理されている

## ビジネス要件

HRL の株主は、予測機能の強化と、新興市場の視聴者のレイテンシ低減を求めています。株主からの要件は次のとおりです：

- パートナー向けに予測モデルを公開できるようサポートする
- 以下に関して、レース中およびレース前の予測機能を向上させる：
  - レース結果
  - 機械の故障
  - 聴衆の感情
- テレメトリーを増やし、追加の分析情報を作成する
- 新しい予測でファンのエンゲージメントを測定する
- 放送のグローバルな可用性と品質を向上させる
- 同時視聴が可能なユーザー数を増やす
- 運用の複雑さを最小化する
- 確実に規制を遵守する
- マーチャンダイジングの収益源を作る

## 技術的要件

- 予測のスループットと精度を維持、強化する
- 視聴者のレイテンシを低減する
- コード変換のパフォーマンスを向上させる
- 視聴者の消費パターンとエンゲージメントをリアルタイムで分析する
- データマートを作成して大規模なレースデータを処理できるようにする

## 経営陣のメッセージ

当社の CEO である S. Hawke は、世界中のファンの皆様に気持ちが高ぶるようなレースを届けたいと考えています。ファンの皆様のお声を反映して、追い抜きなどのレース中のイベントの予測を取り入れ、動画ストリーミングを強化したいと考えています。現在のプラットフォームでもレース結果を予測することはできますが、レース中のリアルタイム予測に対応できる施設と、シーズン全体の結果を処理するキャパシティが不足しています。