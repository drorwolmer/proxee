#!/bin/bash

set -euo pipefail

IGNORE='.*'
if [ "$INTERCEPT" == "1" ]; then
        echo "IGNORINNG"
        IGNORE='foo'
fi

if [ -z "${BASENAME:-}" ]; then
        echo "[-] Must set BASENAME env"
        exit 1
fi

export PROXY_AUTH
export IGNORE
export BASENAME

exec /usr/local/bin/supervisord -c /usr/local/etc/supervisord.conf
