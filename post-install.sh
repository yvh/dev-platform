#!/usr/bin/env bash

set -e

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
makepkg -si
cd ..
rm -rf yay

yay -S google-chrome 
yay -S filezilla
yay -S bat
yay -S ca-certificates
yay -S git-delta
yay -S jq kdiff3 kompare openbsd-netcat
yay -S rsync
yay -S zsh
yay -S ttf-dejavu ttf-lato
yay -S ttf-opensans
yay -S noto-fonts noto-fonts-emoji
yay -S powerline-fonts
yay -S eza
yay -S docker docker-compose
sudo systemctl enable docker.socket
sudo gpasswd -a yvh docker
yay -S pdfsam
yay -S postman
yay -S visual-studio-code-bin
yay -S openshift-client-bin
yay -S mkcert
yay -S stunnel
yay -S libreoffice-fresh
yay -S ttf-caladea ttf-carlito
yay -S ttf-dejavu ttf-liberation
yay -S noto-fonts
yay -S ttf-opensans ttf-lato powerline-fonts ttf-roboto ttf-roboto-mono ttf-symbola
yay -S openssh sshfs
yay -S glab
yay -S mariadb-clients
yay -S gitflow-cjs
yay -S nginx-mainline
yay -S linux-headers
yay -S displaylink
