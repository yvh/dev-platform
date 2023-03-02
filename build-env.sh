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

sudo apt update && sudo apt -y full-upgrade
sudo apt install -y build-essential apt-transport-https ca-certificates gnupg-agent software-properties-common \
    vim curl subversion sshfs htop zsh libreoffice libreoffice-style-breeze filezilla \
    ttf-bitstream-vera fonts-dejavu fonts-hack fonts-lato fonts-open-sans fonts-roboto fonts-powerline gnome-tweaks \
    hyphen-fr mythes-fr ttf-mscorefonts-installer cntlm terminator
sudo apt install -y --no-install-recommends kdiff3 wireshark

# remove snapd
sudo snap remove firefox gnome-3-38-2004
sudo snap remove gtk-common-themes
sudo snap remove snapd-desktop-integration
sudo snap remove snap-store
sudo snap remove core20
sudo snap remove bare
sudo snap remove snapd
sudo apt -y autoremove --purge snapd
rm -rf ~/snap ~/Downloads/firefox.tmp

# firefox
curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x0ab215679c571d1c8325275b9bdb3d89ce49ec21" | sudo gpg --dearmor -o /etc/apt/keyrings/firefox.gpg
echo "Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/firefox.gpg
URIs: https://ppa.launchpadcontent.net/mozillateam/ppa/ubuntu
Suites: $(lsb_release -cs)
Components: main" | sudo tee /etc/apt/sources.list.d/firefox.sources
sudo apt update
echo 'Package: *                  
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001' | sudo tee /etc/apt/preferences.d/firefox
sudo apt install -y firefox

# github cli
curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2c6106201985b60e6c7ac87323f3d4ea75716059" | sudo gpg --dearmor -o /etc/apt/keyrings/github.gpg
echo "Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/github.gpg
URIs: https://cli.github.com/packages
Suites: stable
Components: main" | sudo tee /etc/apt/sources.list.d/github.sources
sudo apt update && sudo apt install -y gh

# visual studio code
curl -fsSL "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -o /tmp/code_amd64.deb

sudo apt install -y /tmp/code_amd64.deb

# customization
sudo update-alternatives --set editor /usr/bin/vim.basic
sudo sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' /root/.bashrc
sudo sed -i 's/01;32m/01;31m/' /root/.bashrc
sudo apt install -y msmtp
chmod g-w msmtprc
sudo cp msmtprc /etc/msmtprc

# remove uneccessary apps
sudo apt-get purge -y fonts-lohit* fonts-tlwg* fonts-samyak* fonts-tibetan-machine fonts-lklug-sinhala nano \
    skanlite kio-audiocd thunderbird
sudo apt autoremove --purge -y
rm -rf ~/.cache/mozilla ~/.mozilla

# set mailhog
sudo curl -fsSL "https://github.com/mailhog/MailHog/releases/download/v1.0.1/MailHog_linux_amd64" -o /usr/local/bin/mailhog
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

# remove uneccessary dirs
echo "enabled=False" > ~/.config/user-dirs.conf
sed -i 's/XDG_TEMPLATES_DIR/#XDG_TEMPLATES_DIR/' ~/.config/user-dirs.dirs
sed -i 's/XDG_PUBLICSHARE_DIR/#XDG_PUBLICSHARE_DIR/' ~/.config/user-dirs.dirs
sed -i 's/XDG_DOCUMENTS_DIR/#XDG_DOCUMENTS_DIR/' ~/.config/user-dirs.dirs
sed -i 's/XDG_MUSIC_DIR/#XDG_MUSIC_DIR/' ~/.config/user-dirs.dirs
sed -i 's/XDG_PICTURES_DIR/#XDG_PICTURES_DIR/' ~/.config/user-dirs.dirs
sed -i 's/XDG_VIDEOS_DIR=/#XDG_VIDEOS_DIR=/' ~/.config/user-dirs.dirs

# Oh my zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
