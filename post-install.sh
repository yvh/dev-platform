#!/usr/bin/env bash
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo --preserve-env bash "$0" "$@"
fi

sudo sed --in-place 's/^#Color$/Color/' /etc/pacman.conf
grep --quiet --fixed-strings 'ILoveCandy' /etc/pacman.conf || sudo sed --in-place '/^Color$/a ILoveCandy' /etc/pacman.conf

sudo sed --in-place '/^OPTIONS=/{s/ debug/ !debug/}' /etc/makepkg.conf

git clone https://aur.archlinux.org/yay.git
cd yay/
makepkg --syncdeps --install
cd ..
rm --recursive --force yay

yay --sync \
  bat \
  claude-code \
  docker \
  docker-buildx \
  docker-compose \
  eza \
  git-delta \
  gitflow-cjs \
  glab \
  globalprotect-openconnect \
  jq \
  kdiff3 \
  mariadb-clients \
  mkcert \
  nginx-mainline \
  noto-fonts \
  noto-fonts-emoji \
  openai-codex \
  openbsd-netcat \
  openshift-client-bin \
  openssh \
  ripgrep \
  rsync \
  stunnel \
  zsh
  
sudo systemctl enable docker.socket
sudo gpasswd --add yvh docker
sudo ln --symbolic --force $PWD/nginx.conf /etc/nginx/nginx.conf
sudo systemctl enable --now nginx.service

# Caution if latest version, if not => fork
yay --sync sing-box-extended
