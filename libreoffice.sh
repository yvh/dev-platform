#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo bash "$0" "$@"
fi

echo "📄 Installing LibreOffice..."
apt update && apt install --assume-yes \
    libreoffice-calc \
    libreoffice-draw \
    libreoffice-gnome \
    libreoffice-impress \
    libreoffice-math \
    libreoffice-nlpsolver \
    libreoffice-numbertext \
    libreoffice-script-provider-python \
    libreoffice-writer \
    libreoffice-writer2latex \
    libreoffice-writer2xhtml
