# gsp0528 - Connecting Cloud Networks with NCC

[Connecting Cloud Networks with NCC - Establish Site to Site Connectivity with HA-VPN using NCC | Google Cloud Skills Boost](https://www.cloudskillsboost.google/paths/14/course_templates/1364/labs/555695)

## 概要

Network Connectivity Center (NCC) を使用して、複数のオフィス間でサイト間接続を確立する。HA-VPN を使用してハブ＆スポーク構造を構築し、オフィス間の通信を可能にする。

## 主要なコマンド

### 1. Network Connectivity API を有効化
```bash
gcloud services enable networkconnectivity.googleapis.com
```

### 2. NCC ハブを作成
```bash
gcloud network-connectivity hubs create HUB_NAME
```

### 3. VPN スポークを作成（各オフィス用）
```bash
# Office 1 のスポーク
gcloud network-connectivity spokes linked-vpn-tunnels create OFFICE_1_SPOKE \
  --hub HUB_NAME \
  --vpn-tunnels VPN_TUNNEL_1,VPN_TUNNEL_2 \
  --region REGION \
  --site-to-site-data-transfer

# Office 2 のスポーク
gcloud network-connectivity spokes linked-vpn-tunnels create OFFICE_2_SPOKE \
  --hub HUB_NAME \
  --vpn-tunnels VPN_TUNNEL_3,VPN_TUNNEL_4 \
  --region REGION \
  --site-to-site-data-transfer
```

### 4. スポークの確認
```bash
gcloud network-connectivity hubs list-spokes HUB_NAME
```

### 5. 接続性の検証
```bash
# Office 1 VM から Office 2 VM へ ping
gcloud compute ssh onprem-office1-vm --command "ping -c 3 OFFICE_2_VM_IP"
```

### 6. リソースのクリーンアップ
```bash
# スポークを削除
gcloud network-connectivity spokes delete SPOKE_NAME --region REGION

# ハブを削除
gcloud network-connectivity hubs delete HUB_NAME
```

## 実行方法
```bash
./run.sh --region REGION --zone ZONE --routing-vpc-tunnel-name TUNNEL_NAME [その他のパラメータ]
```
