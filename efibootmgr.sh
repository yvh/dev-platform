#!/usr/bin/env bash

set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo --preserve-env bash "$0" "$@"
fi

echo "🔐 Installing essential tools for EFI boot management..."
pacman -Sy --noconfirm \
  networkmanager \
  efibootmgr


mkdir --parents /etc/NetworkManager/conf.d
cat > /etc/NetworkManager/conf.d/20-connectivity.conf << EOF
[connectivity]
enabled=false
EOF

systemctl enable NetworkManager
