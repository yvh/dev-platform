#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo bash "$0" "$@"
fi

echo "🧠 Installing Visual Studio Code..."
curl --silent --show-error --fail --location "https://packages.microsoft.com/keys/microsoft.asc" | gpg --dearmor --output /etc/apt/keyrings//microsoft.gpg
echo "Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/microsoft.gpg
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main" | tee /etc/apt/sources.list.d/vscode.sources > /dev/null
apt update && apt install --assume-yes code
