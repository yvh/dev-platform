#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo -E bash "$0" "$@"
fi

echo "🌐 Installing nginx..."
curl --silent --show-error --fail --location "https://nginx.org/keys/nginx_signing.key" | gpg --dearmor --output /etc/apt/keyrings/nginx.gpg > /dev/null
cat > /etc/apt/sources.list.d/nginx.sources << EOF
Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/nginx.gpg
URIs: https://nginx.org/packages/debian
Suites: $(lsb_release --codename --short)
Components: nginx
EOF
apt update && apt install --no-install-recommends --no-install-suggests --assume-yes nginx
