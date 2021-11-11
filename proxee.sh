#!/bin/bash

set -euo pipefail

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PROXY_AUTH=${AUTH:-}
IGNORE=""

if [ "${INTERCEPT:-}" == "1" ]; then
        IGNORE="1"
fi

export PROXY_AUTH
export IGNORE

# Check if certs exist
# This is to avoid a race condition between the two proxies
# We want them to use the same certificates
if [ ! -f "$CURRENT_DIR/certs/mitmproxy-ca.pem" ]; then
        echo "[+] Creating certs for first run"
        docker-compose up -d mitmproxy
        sleep 3
fi

if [ ! -f "$CURRENT_DIR/certs/mitmproxy-ca.pem" ]; then
        echo "[-] Could not create certs..."
        exit 1
fi

echo "[+] Bringing up mitmproxy"
(
        cd "$CURRENT_DIR"
        docker-compose up -d
)

echo "[+] Proxy is listening on 0.0.0.0:8080 and 0.0.0.0:8443"
