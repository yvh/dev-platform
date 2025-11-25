#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo -E bash "$0" "$@"
fi

echo "📄 Installing LibreOffice..."
apt update && apt install --no-install-recommends --no-install-suggests --assume-yes \
  libreoffice-calc \
  libreoffice-draw \
  libreoffice-gnome \
  libreoffice-impress \
  libreoffice-kf6 \
  libreoffice-math \
  libreoffice-nlpsolver \
  libreoffice-numbertext \
  libreoffice-script-provider-python \
  libreoffice-style-breeze \
  libreoffice-writer \
  libreoffice-writer2latex \
  libreoffice-writer2xhtml
