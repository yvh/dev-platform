#!/usr/bin/env bash

set -ex

# /tmp to tmpfs
sudo cp -v /usr/share/systemd/tmp.mount /etc/systemd/system/ 
sudo systemctl enable --now tmp.mount

# Upgrade & install some apps
sudo add-apt-repository -y ppa:libreoffice/ppa
sudo add-apt-repository -y ppa:git-core/ppa

sudo apt -y full-upgrade
sudo apt install -y build-essential apt-transport-https ca-certificates gnupg-agent software-properties-common \
    tlp vim curl ubuntu-restricted-extras subversion git sshfs htop zsh gimp gimp-data-extras libreoffice libreoffice-style-breeze \
    gnome-tweak-tool msmtp
sudo apt install --no-install-recommends kdiff3 wireshark

sudo update-alternatives --set editor /usr/bin/vim.basic
sudo sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' /root/.bashrc
sudo sed -i 's/01;32m/01;31m/' /root/.bashrc
sudo cp msmtprc /etc/msmtprc

sudo apt-get purge -y fonts-lohit* fonts-tlwg* fonts-samyak* fonts-tibetan-machine fonts-lklug-sinhala nano

# Oh my zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# set mailhog
sudo curl -sSL https://github.com/mailhog/MailHog/releases/download/v1.0.1/MailHog_linux_amd64 -o /usr/local/bin/mailhog
sudo chmod +x /usr/local/bin/mailhog
sudo cp mailhog.service /etc/systemd/system/mailhog.service
sudo systemctl enable --now mailhog

# atom
curl -sL https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key --keyring /etc/apt/trusted.gpg.d/atom.gpg add -
sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
sudo apt update && sudo apt install -y --no-install-recommends atom

# nodejs & yarn
#curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
curl -sL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/nodesource.gpg add -
sudo sh -c 'echo "deb https://deb.nodesource.com/node_14.x $(lsb_release -cs) main" > /etc/apt/sources.list.d/nodesource.list'
sudo sh -c 'echo "#deb-src https://deb.nodesource.com/node_14.x $(lsb_release -cs) main" >> /etc/apt/sources.list.d/nodesource.list'
sudo apt update && sudo apt install -y nodejs
sudo npm install -g yarn

# apache
./build-apache.sh

# mariadb
./build-mariadb.sh

sudo add-apt-repository ppa:serge-rider/dbeaver-ce
sudo apt update && sudo apt install -y dbeaver-ce

# php
sudo add-apt-repository ppa:ondrej/php
./build-php.sh
sudo mkdir -p /var/www/html/phpinfo
sudo sh -c 'echo "<?php phpinfo();" > /var/www/html/phpinfo/index.php'

# docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key --keyring /etc/apt/trusted.gpg.d/docker.gpg add -
sudo sh -c 'echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list'
sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker yvh

# spotify
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key --keyring /etc/apt/trusted.gpg.d/spotify.gpg add -
sudo sh -c 'echo "deb http://repository.spotify.com stable non-free" > /etc/apt/sources.list.d/spotify.list'
sudo apt update && sudo apt install spotify-client

# change inotify for idea (phpstorm)
sudo sh -c 'echo "fs.inotify.max_user_watches = 524288" > /etc/sysctl.d/10-idea.conf'
sudo sysctl -p --system
