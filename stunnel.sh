#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo --preserve-env bash "$0" "$@"
fi

echo "🔐 Installing stunnel4..."
apt update && apt install --no-install-recommends --no-install-suggests --assume-yes stunnel4
systemctl disable stunnel4
systemctl stop stunnel4 || true
