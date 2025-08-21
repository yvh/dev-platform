#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo bash "$0" "$@"
fi

echo "🌐 Installing Google Chrome..."
curl --silent --show-error --fail --location "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" --output /tmp/google-chrome-stable_current_amd64.deb
apt install --no-install-recommends --no-install-suggests --assume-yes /tmp/google-chrome-stable_current_amd64.deb
rm --recursive --force /tmp/google-chrome-stable_current_amd64.deb
