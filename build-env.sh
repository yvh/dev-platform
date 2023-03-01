#!/usr/bin/env bash

set -ex

# /tmp to tmpfs
sudo cp -v /usr/share/systemd/tmp.mount /etc/systemd/system/
sudo systemctl enable --now tmp.mount

# upgrade & install some apps
#sudo add-apt-repository -y ppa:libreoffice/ppa
sudo apt-key --keyring /etc/apt/trusted.gpg.d/libreoffice.gpg adv --keyserver keyserver.ubuntu.com --recv-key 36E81C9267FD1383FCC4490983FBA1751378B444
sudo sh -c 'echo "deb https://ppa.launchpadcontent.net/libreoffice/ppa/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/libreoffice.list'
sudo sh -c 'echo "#deb-src https://ppa.launchpadcontent.net/libreoffice/ppa/ubuntu $(lsb_release -cs) main" >> /etc/apt/sources.list.d/libreoffice.list'

sudo apt update && sudo apt -y full-upgrade
sudo apt install -y build-essential apt-transport-https ca-certificates gnupg-agent software-properties-common \
    vim curl subversion sshfs htop zsh libreoffice libreoffice-style-breeze filezilla \
    ttf-bitstream-vera fonts-dejavu fonts-hack fonts-lato fonts-open-sans fonts-roboto fonts-powerline gnome-tweaks \
    hyphen-fr mythes-fr ttf-mscorefonts-installer cntlm
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
sudo apt-key --keyring /etc/apt/trusted.gpg.d/firefox.gpg adv --keyserver keyserver.ubuntu.com --recv-key 0AB215679C571D1C8325275B9BDB3D89CE49EC21
sudo sh -c 'echo "deb https://ppa.launchpadcontent.net/mozillateam/ppa/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/firefox.list'
sudo sh -c 'echo "#deb-src https://ppa.launchpadcontent.net/mozillateam/ppa/ubuntu $(lsb_release -cs) main" >> /etc/apt/sources.list.d/firefox.list'
sudo apt update
echo 'Package: *                  
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001' | sudo tee /etc/apt/preferences.d/firefox
sudo apt install -y firefox

# github cli
sudo apt-key --keyring /etc/apt/trusted.gpg.d/github.gpg adv --keyserver keyserver.ubuntu.com --recv-key 23F3D4EA75716059
sudo sh -c 'echo "deb https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github.list'
sudo sh -c 'echo "#deb-src https://cli.github.com/packages stable main" >> /etc/apt/sources.list.d/github.list'
sudo apt update && sudo apt install -y gh

# visual studio code
curl -SL "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -o /tmp/code_amd64.deb
sudo apt install -y /tmp/code_amd64.deb

# postman
#curl https://gist.githubusercontent.com/SanderTheDragon/1331397932abaa1d6fbbf63baed5f043/raw/postman-deb.sh | sh

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
sudo curl -SL https://github.com/mailhog/MailHog/releases/download/v1.0.1/MailHog_linux_amd64 -o /usr/local/bin/mailhog
sudo chmod +x /usr/local/bin/mailhog
chmod g-w mailhog.service
sudo cp mailhog.service /etc/systemd/system/mailhog.service
sudo systemctl enable --now mailhog

# nodejs & yarn
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

# apache
./build-apache.sh

# mariadb
./build-mariadb.sh

# dbeaver
curl -sL https://dbeaver.io/debs/dbeaver.gpg.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/dbeaver-ce.gpg add -
sudo sh -c 'echo "deb https://dbeaver.io/debs/dbeaver-ce /" > /etc/apt/sources.list.d/dbeaver-ce.list'
sudo apt update && sudo apt install -y dbeaver-ce

# php
sudo apt-key --keyring /etc/apt/trusted.gpg.d/php.gpg adv --keyserver keyserver.ubuntu.com --recv-key 14AA40EC0831756756D7F66C4F4EA0AAE5267A6C
sudo sh -c 'echo "deb https://ppa.launchpadcontent.net/ondrej/php/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/php.list'
sudo sh -c 'echo "#deb-src https://ppa.launchpadcontent.net/ondrej/php/ubuntu $(lsb_release -cs) main" >> /etc/apt/sources.list.d/php.list'
sudo apt update
./build-php.sh
sudo mkdir -p /var/www/html/phpinfo
sudo sh -c 'echo "<?php phpinfo();" > /var/www/html/phpinfo/index.php'

# docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key --keyring /etc/apt/trusted.gpg.d/docker.gpg add -
sudo sh -c 'echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list'
sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker yvh

DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.16.0/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
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
