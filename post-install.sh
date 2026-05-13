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
  docker \
  docker-buildx \
  docker-compose \
  eza \
  git-delta \
  gitflow-cjs \
  glab \
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
