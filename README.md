# Traefik v3 with Cloudflared Tunnel Setup

このリポジトリは、Traefik v3とCloudflared Tunnelを使用して、コンテナ内で定義されたサブドメインにアクセスできる環境を構築するための設定ファイルです

## 概要

このセットアップでは以下の構成を実現しています：

1. Cloudflared Tunnelを使用して、インターネットからのトラフィックを安全に内部ネットワークに転送
1. Traefikを使用して、転送されたトラフィックを適切なコンテナにルーティング
1. コンテナ内で定義されたサブドメインに基づいて、各サービスにアクセス可能

## 前提条件

- Docker と Docker Compose がインストールされていること
- Cloudflare アカウントを持っていること
- ドメインがCloudflareで管理されていること

## セットアップ手順

1. このリポジトリをクローンします
1. Cloudflare tunnelを作成します
1. .envファイルにCloudflare tunnelのtokenと、指定のドメインを入力します
1. `docker compose up -d`でコンテナを起動します
1. traefikとcloudflaredが起動したことを確認します
1. CloudflareのサイトでConnectorが接続されていることを確認します
1. TunnelでPublic hostnameに、`*.${DOMEIN}`を`HTTP://traefik`サービスに転送されるようにします
    - 2LDなら証明書は不要ですが、3LD以降だとlet's encryptをなどでHTTPSにすることをお勧めします
1. DNSを`CNAME`に`*.${DOMAIN}`が、`${Tunnel ID}.cfargotunnel.com`に転送されるようにします
    - `example.com`を所有しており、`*.example.com`に転送する場合、`CNAME`は`*`
    - `example.com`を所有しており、`*.traefik.example.com`に転送する場合、`CNAME`は`*.traefik`
        - こちらの場合証明書を発行して、HTTPSで接続するようにしないとHTTPでしか接続できない
1. `cd demo/whoami/; docker compose up -d`でwhoamiを起動します
1. `whoami.${DOMAIN}`にアクセスして、接続できる確認する
1. 同じように、公開するコンテナを`traefik-network`のネットワークに接続してtraefikの設定をするだけで公開することができる
