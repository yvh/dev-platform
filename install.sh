#!/usr/bin/env bash

set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo --preserve-env bash "$0" "$@"
fi

echo ""
echo "🧙 ‘Ah... you are root. A power not to be taken lightly.’"
echo "📜 Summoning the script from the archives of GitHub..."
echo ""

echo ""
echo "📥 Installing essential tools and desktop apps..."
pacman --sync --refresh --noconfirm \
  base-devel \
  exfatprogs \
  gdm \
  git \
  gnome-control-center \
  gnome-keyring \
  gnome-session \
  gnome-settings-daemon \
  gnome-shell \
  gnome-text-editor \
  gtkmm3 \
  htop \
  less \
  mutter \
  nautilus \
  nss \
  nvim \
  pipewire \
  pipewire-alsa \
  pipewire-audio \
  pipewire-pulse \
  plymouth \
  unzip \
  wezterm \
  wireplumber \
  xdg-user-dirs \
  xdg-utils \
  xz

systemctl enable gdm.service
plymouth-set-default-theme -R bgrt
# Don't forget to add plymouth to the HOOKS in /etc/mkinitcpio.conf and regenerate the initramfs with mkinitcpio -P
# add splash to kernel /etc/kernel/cmdline

# customization
echo ""
echo "🧾 Adjusting network and terminal settings..."
ln --symbolic --force /usr/bin/nvim /usr/bin/vi
ln --symbolic --force /usr/bin/nvim /usr/bin/vim

if grep --quiet "^[[:space:]]*SendEnv" /etc/ssh/ssh_config 2>/dev/null; then
  sed --in-place 's/^[[:space:]]*SendEnv/# &/g' /etc/ssh/ssh_config || true
fi

echo ""
echo "🔧 Tuning inotify settings for IDEs..."
echo "fs.inotify.max_user_watches = 1048576" > /etc/sysctl.d/99-idea.conf
sysctl --system

echo ""
echo "✅ ‘The script has run its course... may your server never segfault again.’"
