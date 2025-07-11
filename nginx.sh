#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo bash "$0" "$@"
fi

echo "🌐 Installing nginx..."
curl --silent --show-error --fail --location "https://nginx.org/keys/nginx_signing.key" | gpg --dearmor --output /etc/apt/keyrings/nginx.gpg > /dev/null
echo "Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/nginx.gpg
URIs: http://nginx.org/packages/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: nginx" | tee /etc/apt/sources.list.d/nginx.sources > /dev/null
apt update && apt install --assume-yes nginx
