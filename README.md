# PROXEE

Easily test various proxy configurations:

## How it works

- uses [mitmproxy](https://mitmproxy.org/) under the hood
  
  Read `docker-compose.yml` to see the trick which enables listening on `https://`
- Starts a proxy which listens on two ports, both `http` and `https`:
  - `8080` for the web traffic
  - one for the API traffic

## Usage

```sh
# Proxy without authentication and SSL Interception
./proxee.sh

# Add Proxy Authentication
AUTH="admin:123456" ./proxee.sh

# Enable SSL Interception
INTERCEPT=1 ./proxee.sh

# Both Auth and Intercept
INTERCEPT=1 AUTH="admin:123456" ./proxee.sh
```

## How do I test SSL Interception

1. Install `mitmproxy` root certificate from `certs/`
   (https://docs.mitmproxy.org/stable/concepts-certificates/)

```sh
INTERCEPT=1 ./proxee.sh
curl https://google.com -x http://localhost:8080 -vv
```

## How do I test a proxy listening on `https://`

1. Create a DNS record (or edit `/etc/hosts`) for the proxy server
2. Install the root certificate on the client

```sh
./proxee.sh
curl https://google.com -x https://proxy.foo:8443 -vv
```
