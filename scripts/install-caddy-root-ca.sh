#!/usr/bin/env sh
set -eu

CRT_PATH="${1:-}"

if [ -z "$CRT_PATH" ] || [ ! -f "$CRT_PATH" ]; then
  echo "usage: $0 /path/to/root.crt" >&2
  exit 1
fi

case "$(uname -s)" in
  Linux)
    if command -v update-ca-certificates >/dev/null 2>&1; then
      sudo install -m 0644 "$CRT_PATH" /usr/local/share/ca-certificates/caddy-root-ca.crt
      sudo update-ca-certificates
    elif command -v update-ca-trust >/dev/null 2>&1; then
      sudo install -m 0644 "$CRT_PATH" /etc/pki/ca-trust/source/anchors/caddy-root-ca.crt
      sudo update-ca-trust extract
    else
      echo "unsupported Linux trust store: install update-ca-certificates or update-ca-trust" >&2
      exit 1
    fi
    ;;
  Darwin)
    sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain "$CRT_PATH"
    ;;
  *)
    echo "unsupported platform: $(uname -s)" >&2
    exit 1
    ;;
esac

echo "installed Caddy root CA from $CRT_PATH"
