#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo bash "$0" "$@"
fi

echo "🌐 Installing GlobalProtect-openconnect..."
curl --silent --show-error --fail --location "$(curl --silent --location https://api.github.com/repos/yuezk/GlobalProtect-openconnect/releases/latest | jq --raw-output '.assets[] | select(.name | match("amd64.deb$")) | .browser_download_url')" --output /tmp/gpoc.deb
apt install --assume-yes /tmp/gpoc.deb
rm --recursive --force /tmp/gpoc.deb
