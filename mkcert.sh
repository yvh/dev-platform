#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo --preserve-env bash "$0" "$@"
fi

if command -v "certutil" >/dev/null 2>&1; then
    echo "✅ certutil is already installed, skipping certutil (libnss3-tools) installation."
else
    echo "🔐 Installing certutil (libnss3-tools)..."
    apt update && apt install --no-install-recommends --no-install-suggests --assume-yes libnss3-tools
fi

echo "🔐 Installing mkcert..."
curl --silent --show-error --fail --location --output /usr/local/bin/mkcert "https://dl.filippo.io/mkcert/latest?for=linux/amd64"
chmod +x /usr/local/bin/mkcert
