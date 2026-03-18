#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo --preserve-env bash "$0" "$@"
fi

ROOT_PARTUUID="$(blkid -s PARTUUID -o value "$(findmnt -no SOURCE /)")"
EFI_PART="$(findmnt -no SOURCE /boot)"
EFI_DISK="/dev/$(lsblk -no PKNAME "$EFI_PART")"
EFI_PARTNUM="$(cat /sys/class/block/$(basename "$EFI_PART")/partition)"

efibootmgr --create \
  --disk "$EFI_DISK" \
  --part "$EFI_PARTNUM" \
  --label "Arch Linux EFI Stub Fallback" \
  --loader '\vmlinuz-linux' \
  --unicode "root=PARTUUID=$ROOT_PARTUUID rw quiet splash loglevel=3 udev.log_level=3 rd.systemd.show_status=false vt.global_cursor_default=0 initrd=\intel-ucode.img initrd=\initramfs-linux-fallback.img" \
  --verbose

# echo "==> Installation de systemd-boot"
# bootctl install

# echo "==> Création de /boot/loader/loader.conf"
# mkdir -p /boot/loader
# cat > /boot/loader/loader.conf <<EOF
# default arch.conf
# timeout 3
# console-mode max
# editor no
# EOF

# echo "==> Création de /boot/loader/entries/arch.conf"
# mkdir -p /boot/loader/entries
# cat > /boot/loader/entries/arch.conf <<EOF
# title   Arch Linux
# linux   /vmlinuz-linux
# initrd  /intel-ucode.img
# initrd  /initramfs-linux.img
# options root=PARTUUID=${ROOT_PARTUUID} rw quiet splash loglevel=3 udev.log_level=3 rd.systemd.show_status=false vt.global_cursor_default=0
# EOF

# echo "==> Vérification"
# bootctl status

# echo
# echo "Terminé."
# echo "PARTUUID détecté : ${ROOT_PARTUUID}"
# echo "Entrée créée : /boot/loader/entries/arch.conf"