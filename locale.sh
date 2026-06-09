#!/usr/bin/env bash
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo --preserve-env bash "$0" "$@"
fi

echo "🌍 Setting system locale..."

ln --symbolic --force /usr/share/zoneinfo/Europe/Brussels /etc/localtime
hwclock --systohc

sed --in-place 's/^#en_IE.UTF-8 UTF-8/en_IE.UTF-8 UTF-8/' /etc/locale.gen
echo "LANG=en_IE.UTF-8" > /etc/locale.conf
sed --in-place 's|LANG=${LANG:-C.UTF-8}|[ -f /etc/locale.conf ] \&\& . /etc/locale.conf; LANG=${LANG:-C.UTF-8}|' /etc/profile.d/locale.sh

locale-gen
