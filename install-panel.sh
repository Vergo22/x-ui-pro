#!/bin/bash
set -euo pipefail
[[ $EUID -eq 0 ]] || { echo "Run as root: sudo bash install-panel.sh"; exit 1; }
ROOT="$(cd "$(dirname "$0")" && pwd)"
DB="/etc/x-ui/x-ui.db"
WEB="/var/www/xui-pro-panel"
NGINX="/etc/nginx/conf.d/xui-pro-panel.conf"
[[ -f "$DB" ]] || { echo "XUI database not found: $DB"; exit 1; }
command -v sqlite3 >/dev/null || { echo "sqlite3 is required"; exit 1; }
PORT="$(sqlite3 "$DB" "SELECT value FROM settings WHERE key='webPort' LIMIT 1;")"
BASE="$(sqlite3 "$DB" "SELECT value FROM settings WHERE key='webBasePath' LIMIT 1;")"
PORT="${PORT:-2053}"; BASE="${BASE:-/}"; [[ "$BASE" == /* ]] || BASE="/$BASE"; [[ "$BASE" == */ ]] || BASE="$BASE/"
mkdir -p "$WEB"; cp -a "$ROOT/." "$WEB/"
rm -f "$WEB/install-panel.sh"
# Nginx maps /panel/api/* to the existing X-UI base path and serves /panel/* as static files.
cat > "$NGINX" <<EOF
# Managed by x-ui-pro custom panel
location = /panel { return 301 /panel/; }
location /panel/api/ {
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Requested-With XMLHttpRequest;
    proxy_pass http://127.0.0.1:${PORT}${BASE}panel/api/;
}
location = /panel/login { return 301 /panel/login.html; }
location /panel/ {
    alias ${WEB}/;
    index index.html;
    try_files \$uri \$uri/ /panel/index.html;
}
EOF
nginx -t
systemctl reload nginx
echo
echo "XUI-PRO custom panel installed."
echo "URL: https://YOUR-DOMAIN/panel/"
echo "XUI port: $PORT"
echo "XUI base path: $BASE"
