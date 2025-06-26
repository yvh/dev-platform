#!/usr/bin/env bash

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
apt update && apt install --assume-yes docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo "Which user must be added to docker group?"
read docker_user
usermod --append --groups docker $docker_user
