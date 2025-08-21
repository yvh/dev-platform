#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo bash "$0" "$@"
fi

echo "🐳 Installing Docker..."
curl --silent --show-error --fail --location "https://download.docker.com/linux/debian/gpg" | gpg --dearmor --output /etc/apt/keyrings/docker.gpg > /dev/null
echo "Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/docker.gpg
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable" | tee /etc/apt/sources.list.d/docker.sources > /dev/null
apt update && apt install --no-install-recommends --no-install-suggests --assume-yes \
  containerd.io \
  docker-buildx-plugin \
  docker-ce \
  docker-ce-cli \
  docker-compose-plugin
echo "👤 Adding a user to the docker group..."
usermod --append --groups docker ${USER_OVERRIDE:-$(getent passwd 1000 | cut -d: -f1)}
