# HA VPN接続の構成説明

## 概要

このスクリプトは、Google Cloud Platformでハイアベイラビリティ（HA）VPN接続を設定しています。オンプレミスネットワークとGCPのRouting VPCの間で、BGP（Border Gateway Protocol）を使用した動的ルーティングを確立します。

## 構成要素

### 1. Routing VPC（ハブVPC）

- **ネットワーク名**: `routing-vpc`
- **Cloud Router**: `routing-vpc-cr` (ASN: 64525)
- **VPN Gateway**: `routing-vpc-vpn-gateway`
- **VPN Tunnel**: `routing-vpc-tunnel`
- **ルーターインターフェース**: `if-hub-to-prem` (169.254.1.1/30)
- **BGPピア**: `bgp-hub-to-prem` (ピアIP: 169.254.1.2, ピアASN: 64526)

### 2. On-Premises VPC（オンプレミスVPC）

- **ネットワーク名**: `on-prem-net-vpc`
- **Cloud Router**: `on-prem-router` (ASN: 64526)
- **VPN Gateway**: `on-prem-vpn-gateway`
- **VPN Tunnel**: `on-prem-tunnel`
- **ルーターインターフェース**: `if-prem-to-hub` (169.254.1.2/30)
- **BGPピア**: `bgp-prem-to-hub` (ピアIP: 169.254.1.1, ピアASN: 64525)

## 設定手順

### 1. Cloud Routerの作成

```bash
# Routing VPC用のルーター作成
gcloud compute routers create routing-vpc-cr \
  --region $REGION \
  --network routing-vpc \
  --asn 64525

# On-Prem VPC用のルーター作成
gcloud compute routers create on-prem-router \
  --region $REGION \
  --network on-prem-net-vpc \
  --asn 64526
```

### 2. VPN Gatewayの作成

```bash
# 両方のVPCにVPN Gatewayを作成
gcloud compute vpn-gateways create routing-vpc-vpn-gateway \
  --region $REGION \
  --network routing-vpc

gcloud compute vpn-gateways create on-prem-vpn-gateway \
  --region $REGION \
  --network on-prem-net-vpc
```

### 3. VPN Tunnelの作成

```bash
# 共有シークレットキーの生成
SECRET_KEY=$(openssl rand -base64 24)

# 双方向のVPN Tunnelを作成
gcloud compute vpn-tunnels create routing-vpc-tunnel \
  --vpn-gateway routing-vpc-vpn-gateway \
  --peer-gcp-gateway on-prem-vpn-gateway \
  --router routing-vpc-cr \
  --region $REGION \
  --interface 0 \
  --shared-secret $SECRET_KEY

gcloud compute vpn-tunnels create on-prem-tunnel \
  --vpn-gateway on-prem-vpn-gateway \
  --peer-gcp-gateway routing-vpc-vpn-gateway \
  --router on-prem-router \
  --region $REGION \
  --interface 0 \
  --shared-secret $SECRET_KEY
```

### 4. ルーターインターフェースの設定

```bash
# Routing VPC側のインターフェース
gcloud compute routers add-interface routing-vpc-cr \
  --interface-name if-hub-to-prem \
  --ip-address 169.254.1.1 \
  --mask-length 30 \
  --vpn-tunnel routing-vpc-tunnel \
  --region $REGION

# On-Prem側のインターフェース
gcloud compute routers add-interface on-prem-router \
  --interface-name if-prem-to-hub \
  --ip-address 169.254.1.2 \
  --mask-length 30 \
  --vpn-tunnel on-prem-tunnel \
  --region $REGION
```

### 5. BGPピアの設定

```bash
# Routing VPC側のBGPピア
gcloud compute routers add-bgp-peer routing-vpc-cr \
  --peer-name bgp-hub-to-prem \
  --peer-ip-address 169.254.1.2 \
  --peer-asn 64526 \
  --interface if-hub-to-prem \
  --region $REGION

# On-Prem側のBGPピア
gcloud compute routers add-bgp-peer on-prem-router \
  --peer-name bgp-prem-to-hub \
  --peer-ip-address 169.254.1.1 \
  --peer-asn 64525 \
  --interface if-prem-to-hub \
  --region $REGION
```

### 6. ルート広告の設定

```bash
# Routing VPCからSpoke VPCのサブネットを広告
gcloud compute routers update routing-vpc-cr \
  --advertisement-mode custom \
  --set-advertisement-groups all_subnets \
  --set-advertisement-ranges 10.0.1.0/24 \
  --region $REGION

# On-Premルーターからオンプレミスサブネットを広告
gcloud compute routers update on-prem-router \
  --advertisement-mode custom \
  --set-advertisement-groups all_subnets \
  --region $REGION

# On-Prem側のBGPピアのルート優先度を設定
gcloud compute routers update-bgp-peer on-prem-router \
  --peer-name bgp-prem-to-hub \
  --advertised-route-priority "111" \
  --region $REGION
```

## ネットワークアドレス

- **VPN Tunnel IP Range**: 169.254.1.0/30
  - Routing VPC側: 169.254.1.1
  - On-Prem側: 169.254.1.2
- **Spoke VPC Subnet**: 10.0.1.0/24

## BGP設定

- **Routing VPC ASN**: 64525
- **On-Prem ASN**: 64526
- **ルート優先度**: 111（On-Prem側）

## 動作確認

```bash
# VPN Tunnelの状態確認
gcloud compute vpn-tunnels describe routing-vpc-tunnel \
  --region $REGION \
  --format 'flattened(status,detailedStatus)'

# Cloud Routerの状態確認
gcloud compute routers get-status routing-vpc-cr \
  --region $REGION
```

## 利点

1. **高可用性**: 双方向のVPN接続により冗長性を確保
2. **動的ルーティング**: BGPにより自動的にルート情報を交換
3. **スケーラビリティ**: 新しいVPCやサブネットの追加が容易
4. **セキュリティ**: 共有シークレットキーによる認証
