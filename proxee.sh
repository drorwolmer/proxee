#!/bin/bash

set -euo pipefail

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CONF_BASENAME=${DOMAIN:-mitmproxy}
PROXY_AUTH=${AUTH:-}
IGNORE=""

if [ "$INTERCEPT" == "1" ]; then
        IGNORE="1"
fi

export CONF_BASENAME
export PROXY_AUTH
export IGNORE

echo "[+] Cleaning up"
(
        cd "$CURRENT_DIR"
        docker-compose down -v
)

echo "[+] Bringing up mitmproxy"
(
        cd "$CURRENT_DIR"
        docker-compose up -d mitmproxy
)

if [ "$CONF_BASENAME" != "mitmproxy" ]; then
        cp "$CURRENT_DIR/certs/$CONF_BASENAME-ca-cert.pem" "$CURRENT_DIR/certs/mitmproxy-ca-cert.pem"
        cp "$CURRENT_DIR/certs/$CONF_BASENAME-ca.pem" "$CURRENT_DIR/certs/mitmproxy-ca.pem"
fi

echo "[+] Bringing up traefik"
(
        cd "$CURRENT_DIR"
        docker-compose up traefik mitmproxy
)
