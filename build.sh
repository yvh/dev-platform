#!/usr/bin/env bash

set -ex

# /tmp to tmpfs
sudo cp -v /usr/share/systemd/tmp.mount /etc/systemd/system/
sudo systemctl enable --now tmp.mount

# upgrade & install some apps
sudo apt update && sudo apt -y full-upgrade
sudo apt install -y build-essential apt-transport-https ca-certificates gnupg-agent software-properties-common \
    vim curl sshfs htop zsh gimp gimp-data-extras filezilla inkscape \
    ttf-bitstream-vera fonts-dejavu fonts-hack fonts-lato fonts-open-sans fonts-roboto fonts-powerline vlc \
    ttf-mscorefonts-installer hunspell-fr cntlm openssh-server
sudo apt install -y --no-install-recommends kdiff3 wireshark

# libreoffice
./libreoffice.sh

# remmina
./remmina.sh

# github cli
./github-cli.sh

# google chrome
./google-chrome.sh

# visual studio code
./visual-studio-code.sh

# pdfsam
./pdfsam.sh

# postman
./postman.sh

# msmtp
./msmtp.sh

# customization
sudo update-alternatives --set editor /usr/bin/vim.basic
sudo sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' /root/.bashrc
sudo sed -i 's/01;32m/01;31m/' /root/.bashrc
#sudo sh -c 'echo "[General]
#Numlock=on" >> /etc/sddm.conf'
sudo sh -c 'echo "[connectivity]
enabled=false" > /etc/NetworkManager/conf.d/20-connectivity.conf'

# remove uneccessary apps
sudo apt-get purge -y fonts-lohit* fonts-tlwg* fonts-samyak* fonts-tibetan-machine fonts-lklug-sinhala nano \
    firefox firefox-locale-en skanlite kio-audiocd thunderbird muon kde-config-tablet usb-creator-kde snapd
sudo apt autoremove --purge -y
rm -rf ~/.cache/mozilla ~/.mozilla

# set mailhog
#sudo curl -SL https://github.com/mailhog/MailHog/releases/download/v1.0.1/MailHog_linux_amd64 -o /usr/local/bin/mailhog
#sudo chmod +x /usr/local/bin/mailhog
#chmod g-w mailhog.service
#sudo cp mailhog.service /etc/systemd/system/mailhog.service
#sudo systemctl enable --now mailhog

# OC
./oc.sh

# wkhtmltox
./wkhtmltox.sh

# nodejs & yarn
./nvm.sh

# apache
./apache.sh

# mariadb
./mariadb.sh

# dbeaver
./dbeaver.sh

# php
./php.sh

# docker
./docker.sh

# change inotify for idea (phpstorm)
sudo sh -c 'echo "fs.inotify.max_user_watches = 524288" > /etc/sysctl.d/10-idea.conf'
sudo sysctl -p --system

# full-upgrade
sudo apt -y full-upgrade

sudo apt autoremove --purge -y

# Oh my zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
