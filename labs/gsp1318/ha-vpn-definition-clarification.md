# HA VPNの定義と構成について

## HA VPNの定義の範囲

### 1. 広義のHA VPN
HA VPNは必ずしも**異なるリージョン**に分散させる必要はありません。以下の要素のいずれかを含む構成がHA VPNとみなされます：

#### A. 単一リージョンでの冗長化
```
[On-Premises] ---- VPN Tunnel 1 ---- [GCP Region A]
              ---- VPN Tunnel 2 ----
```
- **同じリージョン内**で複数のVPN Tunnel
- **異なるVPN Gateway**を使用
- **異なるCloud Router**を使用

#### B. 双方向VPN Tunnel
```
[On-Premises] ---- VPN Tunnel (Interface 0) ---- [GCP]
              ---- VPN Tunnel (Interface 1) ----
```
- **同じVPN Gateway**の異なるインターフェース
- **Interface 0**と**Interface 1**を使用

#### C. 地理的分散（最高レベルのHA）
```
[On-Premises] ---- VPN Tunnel 1 ---- [GCP Region A]
              ---- VPN Tunnel 2 ---- [GCP Region B]
```
- **異なるリージョン**にVPN Gateway配置
- **最高レベルの冗長性**

## 先ほどのスクリプトのHA構成分析

### スクリプトの構成
```bash
# 双方向のVPN Tunnelを作成
gcloud compute vpn-tunnels create routing-vpc-tunnel \
  --vpn-gateway routing-vpc-vpn-gateway \
  --peer-gcp-gateway on-prem-vpn-gateway \
  --router routing-vpc-cr \
  --region $REGION \
  --interface 0 \  # ← ここが重要
  --shared-secret $SECRET_KEY

gcloud compute vpn-tunnels create on-prem-tunnel \
  --vpn-gateway on-prem-vpn-gateway \
  --peer-gcp-gateway routing-vpc-vpn-gateway \
  --router on-prem-router \
  --region $REGION \
  --interface 0 \  # ← ここが重要
  --shared-secret $SECRET_KEY
```

### この構成のHAレベル

#### ✅ **HA VPNの基本レベル**
- **双方向のVPN Tunnel**を作成
- **Interface 0**を使用（HA VPNの要件）
- **BGP**による動的ルーティング

#### ❌ **完全なHAではない**
- **同じリージョン**内での構成
- **Interface 1**が設定されていない
- **地理的分散**がない

## HA VPNのレベル分類

### Level 1: 基本的なHA VPN
```bash
# 単一リージョン、Interface 0のみ
gcloud compute vpn-tunnels create tunnel-1 \
  --interface 0 \
  --region us-central1
```

### Level 2: 標準的なHA VPN
```bash
# 単一リージョン、Interface 0 + Interface 1
gcloud compute vpn-tunnels create tunnel-1 \
  --interface 0 \
  --region us-central1

gcloud compute vpn-tunnels create tunnel-2 \
  --interface 1 \
  --region us-central1
```

### Level 3: 高可用性HA VPN
```bash
# 異なるリージョン、Interface 0 + Interface 1
gcloud compute vpn-tunnels create tunnel-1 \
  --interface 0 \
  --region us-central1

gcloud compute vpn-tunnels create tunnel-2 \
  --interface 1 \
  --region us-west1
```

## 先ほどのスクリプトの詳細分析

### 構成要素
1. **2つのVPC**: `routing-vpc` と `on-prem-net-vpc`
2. **2つのVPN Gateway**: 各VPCに1つずつ
3. **2つのVPN Tunnel**: 双方向接続
4. **BGP**: 動的ルーティング

### HAレベル評価

#### ✅ **HA VPNの要素**
- **Interface 0**の使用（HA VPNの基本要件）
- **BGP**による動的ルーティング
- **双方向接続**の確立

#### ⚠️ **制限事項**
- **Interface 1**が未設定
- **単一リージョン**での構成
- **VPN Gateway**の冗長化は部分的

#### 📊 **可用性レベル**
- **99.5%程度**の可用性
- **基本的な冗長性**は確保
- **完全なHA**ではない

## 完全なHA VPNにするには

### 1. Interface 1の追加
```bash
# Interface 1のVPN Tunnelを追加
gcloud compute vpn-tunnels create routing-vpc-tunnel-1 \
  --vpn-gateway routing-vpc-vpn-gateway \
  --peer-gcp-gateway on-prem-vpn-gateway \
  --router routing-vpc-cr \
  --region $REGION \
  --interface 1 \
  --shared-secret $SECRET_KEY

gcloud compute vpn-tunnels create on-prem-tunnel-1 \
  --vpn-gateway on-prem-vpn-gateway \
  --peer-gcp-gateway routing-vpc-vpn-gateway \
  --router on-prem-router \
  --region $REGION \
  --interface 1 \
  --shared-secret $SECRET_KEY
```

### 2. 異なるリージョンへの分散
```bash
# 異なるリージョンにVPN Gatewayを作成
gcloud compute vpn-gateways create routing-vpc-vpn-gateway-secondary \
  --region us-west1 \
  --network routing-vpc
```

## まとめ

### 先ほどのスクリプトの位置づけ
- **HA VPNの基本レベル**の実装
- **双方向VPN Tunnel**による冗長性確保
- **BGP**による動的ルーティング
- **99.5%程度**の可用性

### HA VPNの定義
1. **双方向VPN Tunnel** = HA VPNの基本
2. **Interface 0 + Interface 1** = 標準的なHA VPN
3. **地理的分散** = 最高レベルのHA VPN

つまり、**双方向のVPN Tunnelを作ることも高可用性に含まれる**が、**完全なHA VPN**ではないということです。
