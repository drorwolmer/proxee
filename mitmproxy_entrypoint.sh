#!/bin/sh

echo "[+] Replacing proxy hostname to $CONF_BASENAME" >&2
sed -e 's/CONF_BASENAME = "mitmproxy"/CONF_BASENAME = "'"$CONF_BASENAME"'"/g' -i /usr/lib/python3.8/site-packages/mitmproxy/options.py

exec docker-entrypoint.sh "$@"
