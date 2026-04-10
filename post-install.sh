#!/usr/bin/env bash

set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo --preserve-env bash "$0" "$@"
fi

sudo vim /etc/pacman.conf # Set color and ILoveCandy
sudo vim /etc/makepkg.conf # Set MAKEFLAGS="-j$(nproc)"

git clone https://aur.archlinux.org/yay.git
cd yay/
makepkg --syncdeps --install
cd ..
rm --recursive --force yay

yay --sync \
  bat \
  ca-certificates \
  cups \
  displaylink \
  docker \
  docker-buildx \
  docker-compose \
  eza \
  filezilla \
  git-delta \
  gitflow-cjs \
  glab \
  google-chrome \
  jq \
  kdiff3 \
  kompare \
  libreoffice-fresh \
  linux-headers \
  mariadb-clients \
  mkcert \
  nginx-mainline \
  noto-fonts noto-fonts-emoji \
  nvim \
  openai-codex \
  openbsd-netcat \
  openshift-client-bin \
  openssh \
  pdfsam \
  postman \
  powerline-fonts \
  print-manager \
  ripgrep \
  rsync \
  sshfs \
  stunnel \
  system-config-printer \
  ttf-caladea \
  ttf-carlito \
  ttf-dejavu ttf-lato \
  ttf-jetbrains-mono \
  ttf-jetbrains-mono-nerd \
  ttf-liberation \
  ttf-opensans \
  ttf-roboto \
  ttf-roboto-mono \
  ttf-symbola \
  visual-studio-code-bin \
  zsh

sudo systemctl enable docker.socket
sudo gpasswd -a yvh docker
