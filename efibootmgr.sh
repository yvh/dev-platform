#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo --preserve-env bash "$0" "$@"
fi

ROOT_PARTUUID=$(blkid -s PARTUUID -o value "$(findmnt -no SOURCE /)")
EFI_PART=$(findmnt -no SOURCE /boot)
EFI_DISK="/dev/$(lsblk -no PKNAME "$EFI_PART")"
EFI_PARTNUM="$(lsblk -no PARTNUM "$EFI_PART")"

sudo efibootmgr --create \
  --disk "$EFI_DISK" \
  --part "$EFI_PARTNUM" \
  --label "Arch Linux EFI Stub" \
  --loader '\vmlinuz-linux' \
  --unicode "root=PARTUUID=$ROOT_PARTUUID rw initrd=\intel-ucode.img initrd=\initramfs-linux.img" \
  --verbose