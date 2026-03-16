#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo --preserve-env bash "$0" "$@"
fi

echo "☁️  Installing eza..."
mkdir --parents /etc/apt/keyrings
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/eza-community/eza/main/deb.asc" | gpg --dearmor --output /etc/apt/keyrings/eza.gpg
cat > /etc/apt/sources.list.d/eza.sources << EOF
Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/eza.gpg
URIs: http://deb.gierens.de
Suites: stable
Components: main
EOF
apt update && apt install --no-install-recommends --no-install-suggests --assume-yes eza

