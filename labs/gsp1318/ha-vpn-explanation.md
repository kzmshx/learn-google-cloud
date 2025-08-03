# HA VPN（High Availability VPN）とは

## HA VPNの定義

HA VPNは、**高可用性（High Availability）**を実現するVPN接続の仕組みです。単一障害点（Single Point of Failure）を排除し、ネットワーク接続の継続性を保証します。

## 従来のVPN vs HA VPN

### 従来のVPN（単一接続）

```
[On-Premises] ---- 単一VPN接続 ---- [GCP]
```

- **問題点**: VPN接続が1つだけなので、接続が切れると完全に通信不能
- **リスク**: メンテナンス、障害、設定変更時にダウンタイムが発生

### HA VPN（冗長接続）

```
[On-Premises] ---- VPN接続1 ---- [GCP]
              ---- VPN接続2 ----
```

- **利点**: 複数の接続により、1つが切れても他で通信継続
- **結果**: 99.9%以上の可用性を実現

## HA VPNの実現方法

### 1. 物理的な冗長性

#### VPN Gatewayの冗長化

- **2つのVPN Gateway**を異なるリージョンまたはゾーンに配置
- 1つのGatewayが障害になっても、もう1つが稼働継続

#### インターネット回線の冗長化

- **複数のISP**を使用
- 1つのISPが障害になっても、他で通信継続

### 2. 論理的な冗長性

#### BGP（Border Gateway Protocol）の活用

```bash
# 複数のBGPセッションを確立
gcloud compute routers add-bgp-peer routing-vpc-cr \
  --peer-name bgp-hub-to-prem-1 \
  --peer-ip-address 169.254.1.2 \
  --peer-asn 64526 \
  --interface if-hub-to-prem-1

gcloud compute routers add-bgp-peer routing-vpc-cr \
  --peer-name bgp-hub-to-prem-2 \
  --peer-ip-address 169.254.2.2 \
  --peer-asn 64526 \
  --interface if-hub-to-prem-2
```

#### 動的ルーティング

- BGPが自動的に最適な経路を選択
- 障害が発生すると自動的に代替経路に切り替え

### 3. 接続の種類

#### アクティブ-アクティブ（Active-Active）

```
[On-Premises] ---- VPN1 (Active) ---- [GCP]
              ---- VPN2 (Active) ----
```

- **特徴**: 両方の接続が同時に稼働
- **利点**: 負荷分散、最大の帯域幅
- **用途**: 高帯域幅が必要な場合

#### アクティブ-パッシブ（Active-Passive）

```
[On-Premises] ---- VPN1 (Active) ---- [GCP]
              ---- VPN2 (Standby) ----
```

- **特徴**: 1つがアクティブ、もう1つが待機
- **利点**: シンプルな構成、コスト効率
- **用途**: バックアップ目的

## GCPでのHA VPN実装

### 1. Cloud Routerの冗長化

```bash
# 複数のCloud Routerを作成
gcloud compute routers create router-primary \
  --region us-central1 \
  --network vpc-network \
  --asn 64525

gcloud compute routers create router-secondary \
  --region us-west1 \
  --network vpc-network \
  --asn 64525
```

### 2. VPN Gatewayの冗長化

```bash
# 複数のVPN Gatewayを作成
gcloud compute vpn-gateways create vpn-gateway-primary \
  --region us-central1 \
  --network vpc-network

gcloud compute vpn-gateways create vpn-gateway-secondary \
  --region us-west1 \
  --network vpc-network
```

### 3. VPN Tunnelの冗長化

```bash
# 複数のVPN Tunnelを作成
gcloud compute vpn-tunnels create tunnel-primary \
  --vpn-gateway vpn-gateway-primary \
  --peer-gcp-gateway peer-gateway \
  --router router-primary \
  --region us-central1 \
  --interface 0 \
  --shared-secret $SECRET_KEY

gcloud compute vpn-tunnels create tunnel-secondary \
  --vpn-gateway vpn-gateway-secondary \
  --peer-gcp-gateway peer-gateway \
  --router router-secondary \
  --region us-west1 \
  --interface 0 \
  --shared-secret $SECRET_KEY
```

## 障害時の動作

### 1. 自動検知

- BGPセッションの状態監視
- VPN Tunnelの状態監視
- ネットワーク到達性の確認

### 2. 自動切り替え

```bash
# BGPルートの優先度設定
gcloud compute routers update-bgp-peer router-primary \
  --peer-name bgp-peer-1 \
  --advertised-route-priority "100" \
  --region us-central1

gcloud compute routers update-bgp-peer router-secondary \
  --peer-name bgp-peer-2 \
  --advertised-route-priority "200" \
  --region us-west1
```

### 3. フェイルバック

- 障害が復旧すると自動的に元の経路に戻る
- 手動介入不要

## 監視とアラート

### 1. Cloud Monitoring

```bash
# VPN Tunnelの状態監視
gcloud compute vpn-tunnels describe tunnel-primary \
  --region us-central1 \
  --format 'flattened(status,detailedStatus)'
```

### 2. BGPセッション監視

```bash
# Cloud Routerの状態確認
gcloud compute routers get-status router-primary \
  --region us-central1
```

### 3. ログ監視

- Cloud LoggingでVPN接続のログを収集
- 異常検知とアラート設定

## 設計上の考慮事項

### 1. 地理的分散

- 異なるリージョンにVPN Gatewayを配置
- 自然災害や地域障害への対応

### 2. 帯域幅設計

- 各VPN接続の帯域幅を適切に設計
- 負荷分散時の帯域幅確保

### 3. セキュリティ

- 各VPN接続で異なる共有シークレット
- 暗号化アルゴリズムの統一

## まとめ

HA VPNは以下の要素により高可用性を実現します：

1. **物理的冗長性**: 複数のVPN Gateway、回線
2. **論理的冗長性**: BGPによる動的ルーティング
3. **自動化**: 障害検知と自動切り替え
4. **監視**: 継続的な状態監視とアラート

これにより、99.9%以上の可用性と、計画的なメンテナンス時のダウンタイム最小化を実現できます。
