#!/bin/bash

set -euo pipefail

echo "----------------------------------------------------------------------" >&2
cat >&2 <<EOF
██████  ██████   ██████  ██   ██ ███████ ███████ 
██   ██ ██   ██ ██    ██  ██ ██  ██      ██      
██████  ██████  ██    ██   ███   █████   █████   
██      ██   ██ ██    ██  ██ ██  ██      ██      
██      ██   ██  ██████  ██   ██ ███████ ███████ 
EOF
echo "----------------------------------------------------------------------" >&2

function usage() {
        echo "Usage: $0 [options...]"
        echo -e "-a, --auth <username:password>\tProxy Proxy authentication"
        echo -e "-b, --basename <basename>\tProxy basename [when listening on https://] defaults to proxy.foo"
        echo -e "-i, --intercept\t\t\tEnable SSL Interception"
        echo -e "-h, --help\t\t\tShow this help"
        echo ""
        exit 1
}

BASENAME="proxy.foo"
INTERCEPT=""
PROXY_AUTH=""
UPSTREAM_AUTH=""

while [[ $# -gt 0 ]]; do
        key="$1"

        case $key in
        -b | --basename)
                if [[ -z "${2:-}" ]]; then
                        echo "$1 requires a value"
                        echo ""
                        usage
                fi
                BASENAME="$2"
                shift # past argument
                shift # past value
                ;;
        -i | --intercept)
                INTERCEPT="1"
                shift # past value
                ;;
        -a | --auth)
                if [[ -z "${2:-}" ]]; then
                        echo "$1 requires a value"
                        echo ""
                        usage
                fi
                PROXY_AUTH="$2"
                shift # past argument
                shift # past value
                ;;
        -h | --help)
                usage
                shift # past argument
                ;;

        *)            # unknown option
                shift # past argument
                ;;
        esac
done

IGNORE='.*'
if [ "$INTERCEPT" == "1" ]; then
        IGNORE='foo'
fi

PROXY_URL_HTTP="http://${BASENAME}:8080"
PROXY_URL_HTTPS="https://${BASENAME}:8443"

if [[ ! -z "$PROXY_AUTH" ]]; then
        PROXY_URL_HTTP="http://${PROXY_AUTH}@${BASENAME}:8080"
        PROXY_URL_HTTPS="https://${PROXY_AUTH}@${BASENAME}:8443"
        UPSTREAM_AUTH="--set upstream_auth=${PROXY_AUTH}"
fi

echo "[+] Proxy Listening on $PROXY_URL_HTTP" >&2
echo "[+] Proxy Listening on $PROXY_URL_HTTPS" >&2
if [ "$INTERCEPT" == "1" ]; then
        echo "[+] Doing SSL Interception" >&2
fi
echo "" >&2
echo "[+] Get the CA cert from http://$BASENAME:8000"
echo "----------------------------------------------------------------------" >&2

export PROXY_AUTH
export UPSTREAM_AUTH
export IGNORE
export BASENAME

exec /usr/local/bin/supervisord -c /usr/local/etc/supervisord.conf
