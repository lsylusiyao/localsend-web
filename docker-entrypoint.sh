#!/bin/sh
set -eu

SIGNALING_URL_VALUE="${SIGNALING_URL:-wss://public.localsend.org/v1/ws}"
ESCAPED_SIGNALING_URL=$(printf '%s' "$SIGNALING_URL_VALUE" | sed 's/\\/\\\\/g; s/"/\\"/g')

cat > /usr/share/caddy/runtime-config.js <<EOF
window.__LOCALSEND_RUNTIME_CONFIG__ = {
  signalingUrl: "${ESCAPED_SIGNALING_URL}",
};
EOF

exec "$@"
