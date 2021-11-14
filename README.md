```sh
# ██████  ██████   ██████  ██   ██ ███████ ███████
# ██   ██ ██   ██ ██    ██  ██ ██  ██      ██
  ██████  ██████  ██    ██   ███   █████   █████
# ██      ██   ██ ██    ██  ██ ██  ██      ██
# ██      ██   ██  ██████  ██   ██ ███████ ███████
```

Easily test various proxy configurations:

## How it works

- uses [mitmproxy](https://mitmproxy.org/) under the hood
- uses two proxies, one acting as an SSL terminating reverse proxy
- Starts a proxy which listens on two ports, both `http` and `https`:
  - `8080` for the web traffic
  - one for the API traffic

## Usage

```sh
docker run -v "$(pwd)/certs/:/home/mitmproxy/.mitmproxy" --rm -it -p 8000:8000 -p 8443:8443 -p 8080:8080 drorwolmer/proxee


# Add Proxy Authentication
docker run --rm -it -p 8080:8080 drorwolmer/proxee --auth admin:123456


# Enable SSL Interception
# - Browse http://localhost:8000 to get the certificates
# - Install them according to https://docs.mitmproxy.org/stable/concepts-certificates/
docker run --rm -it -p 8000:8000 -p 8080:8080 drorwolmer/proxee --intercept


# Both Auth and Intercept
INTERCEPT=1 AUTH="admin:123456" ./proxee.sh
```

## How do I test SSL Interception

```sh
docker run --rm -it -p 8000:8000 -p 8080:8080 drorwolmer/proxee --intercept

# - Browse http://localhost:8000 to get the certificates
# - Install them according to https://docs.mitmproxy.org/stable/concepts-certificates
```

## How do I test a proxy listening on `https://`

1. Create a DNS record (or edit `/etc/hosts`) for the proxy server
2. Install the root certificate on the client
3. The proxy will present its certificate with the subject that was requested (`proxy.foo` in the below example)

```sh
docker run \
  --rm \
  -v "$(pwd)/certs/:/home/mitmproxy/.mitmproxy" \
  -it \
  -p 8000:8000 \
  -p 8443:8443 \
  drorwolmer/proxee \
  --intercept --basename proxy.foo
```
