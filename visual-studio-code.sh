#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo bash "$0" "$@"
fi

echo "🧠 Installing Visual Studio Code..."
curl --silent --show-error --location "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" --output /tmp/code_amd64.deb
apt install --assume-yes /tmp/code_amd64.deb
rm --recursive --force /tmp/code_amd64.deb
