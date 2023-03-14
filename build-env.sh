#!/usr/bin/env bash

set -ex

# /tmp to tmpfs
sudo cp -v /usr/share/systemd/tmp.mount /etc/systemd/system/
sudo systemctl enable --now tmp.mount

# upgrade & install some apps
curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x36e81c9267fd1383fcc4490983fba1751378b444" | sudo gpg --dearmor -o /etc/apt/keyrings/libreoffice.gpg
echo "Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/libreoffice.gpg
URIs: https://ppa.launchpadcontent.net/libreoffice/ppa/ubuntu
Suites: $(lsb_release -cs)
Components: main" | sudo tee /etc/apt/sources.list.d/libreoffice.sources

curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x04e38ce134b239b9f38f82ee8a993c2521c5f0ba" | sudo gpg --dearmor -o /etc/apt/keyrings/remmina.gpg
echo "Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/remmina.gpg
URIs: https://ppa.launchpadcontent.net/remmina-ppa-team/remmina-next/ubuntu
Suites: $(lsb_release -cs)
Components: main" | sudo tee /etc/apt/sources.list.d/remmina.sources


sudo apt update && sudo apt -y full-upgrade
sudo apt install -y build-essential apt-transport-https ca-certificates gnupg-agent software-properties-common \
    vim curl subversion sshfs htop zsh gimp gimp-data-extras libreoffice libreoffice-style-breeze filezilla inkscape remmina \
    ttf-bitstream-vera fonts-dejavu fonts-hack fonts-lato fonts-open-sans fonts-roboto fonts-powerline vlc \
    ttf-mscorefonts-installer hunspell-fr network-manager-fortisslvpn cntlm openssh-server
sudo apt install -y --no-install-recommends kdiff3 wireshark

# github cli
curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2c6106201985b60e6c7ac87323f3d4ea75716059" | sudo gpg --dearmor -o /etc/apt/keyrings/github.gpg
echo "Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/github.gpg
URIs: https://cli.github.com/packages
Suites: stable
Components: main" | sudo tee /etc/apt/sources.list.d/github.sources
sudo apt update && sudo apt install -y gh

# google chrome
curl -SL "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" -o /tmp/google-chrome-stable_current_amd64.deb
sudo apt install -y /tmp/google-chrome-stable_current_amd64.deb

# visual studio code
curl -SL "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -o /tmp/code_amd64.deb
sudo apt install -y /tmp/code_amd64.deb

# teams
#curl -SL "https://go.microsoft.com/fwlink/p/?LinkID=2112886&clcid=0x80c&culture=fr-be&country=BE" -o /tmp/teams_amd64.deb
#sudo apt install -y /tmp/teams_amd64.deb

# pdfsam
curl -SL "https://github.com/torakiki/pdfsam/releases/download/v5.0.3/pdfsam_5.0.3-1_amd64.deb" -o /tmp/pdfsam.deb
sudo apt install -y /tmp/pdfsam.deb

# postman
curl https://gist.githubusercontent.com/SanderTheDragon/1331397932abaa1d6fbbf63baed5f043/raw/postman-deb.sh | sh

# atom
#curl -sL https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key --keyring /etc/apt/trusted.gpg.d/atom.gpg add -
#sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
#sudo apt update && sudo apt install -y --no-install-recommends atom

# customization
sudo update-alternatives --set editor /usr/bin/vim.basic
sudo sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' /root/.bashrc
sudo sed -i 's/01;32m/01;31m/' /root/.bashrc
sudo apt install -y msmtp
chmod g-w msmtprc
sudo cp msmtprc /etc/msmtprc
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
sudo curl -SL https://github.com/mailhog/MailHog/releases/download/v1.0.1/MailHog_linux_amd64 -o /usr/local/bin/mailhog
sudo chmod +x /usr/local/bin/mailhog
chmod g-w mailhog.service
sudo cp mailhog.service /etc/systemd/system/mailhog.service
sudo systemctl enable --now mailhog

# nodejs & yarn
curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh" | bash

# apache
./build-apache.sh

# mariadb
./build-mariadb.sh

# dbeaver
curl -fsSL "https://dbeaver.io/debs/dbeaver.gpg.key"  | sudo gpg --dearmor -o /etc/apt/keyrings/dbeaver.gpg
echo "Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/dbeaver.gpg
URIs: https://dbeaver.io/debs/dbeaver-ce
Suites: /" | sudo tee /etc/apt/sources.list.d/dbeaver-ce.sources
sudo apt update && sudo apt install -y dbeaver-ce

# php
curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x14aa40ec0831756756d7f66c4f4ea0aae5267a6c" | sudo gpg --dearmor -o /etc/apt/keyrings/php.gpg
echo "Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/php.gpg
URIs: https://ppa.launchpadcontent.net/ondrej/php/ubuntu
Suites: $(lsb_release -cs)
Components: main" | sudo tee /etc/apt/sources.list.d/php.sources
sudo apt update
./build-php.sh
sudo mkdir -p /var/www/html/phpinfo
sudo sh -c 'echo "<?php phpinfo();" > /var/www/html/phpinfo/index.php'
curl -SL https://raw.githubusercontent.com/composer/getcomposer.org/main/web/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

# docker
curl -fsSL "https://download.docker.com/linux/ubuntu/gpg" | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/docker.gpg
URIs: https://download.docker.com/linux/ubuntu
Suites: $(lsb_release -cs)
Components: stable" | sudo tee /etc/apt/sources.list.d/docker.sources
sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker yvh

DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -fsSL "https://github.com/docker/compose/releases/download/v2.16.0/docker-compose-linux-x86_64" -o $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose

# change inotify for idea (phpstorm)
sudo sh -c 'echo "fs.inotify.max_user_watches = 524288" > /etc/sysctl.d/10-idea.conf'
sudo sysctl -p --system

# full-upgrade
sudo apt -y full-upgrade

sudo apt autoremove --purge -y

# Oh my zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
