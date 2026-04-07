#!/bin/sh
# Generate runtime config from environment variables.
# Loaded before config.js so runtime values take precedence.

cat > /usr/share/nginx/html/runtime-config.js <<EOF
window.CR = window.CR || {};
CR.config = CR.config || {};
CR.config.API_BASE_URL = "${API_BASE_URL:-https://social-care.acdgbrasil.com.br/api/v1}";
CR.config.API_TOKEN = "${API_TOKEN:-}";
EOF

exec "$@"
