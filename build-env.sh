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

#sudo add-apt-repository -y ppa:remmina-ppa-team/remmina-next
sudo apt-key --keyring /etc/apt/trusted.gpg.d/remmina.gpg adv --keyserver keyserver.ubuntu.com --recv-key 04E38CE134B239B9F38F82EE8A993C2521C5F0BA
sudo sh -c 'echo "deb https://ppa.launchpadcontent.net/remmina-ppa-team/remmina-next/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/remmina.list'
sudo sh -c 'echo "#deb-src https://ppa.launchpadcontent.net/remmina-ppa-team/remmina-next/ubuntu $(lsb_release -cs) main" >> /etc/apt/sources.list.d/remmina.list'

sudo apt update && sudo apt -y full-upgrade
sudo apt install -y build-essential apt-transport-https ca-certificates gnupg-agent software-properties-common \
    vim curl subversion sshfs htop zsh gimp gimp-data-extras libreoffice libreoffice-style-breeze filezilla inkscape remmina \
    ttf-bitstream-vera fonts-dejavu fonts-hack fonts-lato fonts-open-sans fonts-roboto fonts-powerline vlc gnome-tweaks \
    network-manager-fortisslvpn-gnome openssh-server hyphen-fr mythes-fr ttf-mscorefonts-installer cntlm
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

# github cli
sudo apt-key --keyring /etc/apt/trusted.gpg.d/github.gpg adv --keyserver keyserver.ubuntu.com --recv-key 23F3D4EA75716059
sudo sh -c 'echo "deb https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github.list'
sudo sh -c 'echo "#deb-src https://cli.github.com/packages stable main" >> /etc/apt/sources.list.d/github.list'
sudo apt update && sudo apt install -y gh

# google chrome
curl -SL "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" -o /tmp/google-chrome-stable_current_amd64.deb
sudo apt install -y /tmp/google-chrome-stable_current_amd64.deb

# visual studio code
curl -SL "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -o /tmp/code_amd64.deb
sudo apt install -y /tmp/code_amd64.deb

# teams
curl -SL "https://go.microsoft.com/fwlink/p/?LinkID=2112886&clcid=0x80c&culture=fr-be&country=BE" -o /tmp/teams_amd64.deb
sudo apt install -y /tmp/teams_amd64.deb

# pdfsam
curl -SL "https://github.com/torakiki/pdfsam/releases/download/v4.3.4/pdfsam_4.3.4-1_amd64.deb" -o /tmp/pdfsam.deb
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
sudo sh -c 'echo "[General]
Numlock=on" >> /etc/sddm.conf'
sudo sh -c 'echo "[connectivity]
enabled=false" > /etc/NetworkManager/conf.d/20-connectivity.conf'

# remove uneccessary apps
sudo apt-get purge -y fonts-lohit* fonts-tlwg* fonts-samyak* fonts-tibetan-machine fonts-lklug-sinhala nano \
    firefox firefox-locale-en skanlite kio-audiocd thunderbird
sudo apt autoremove --purge -y
rm -rf ~/.cache/mozilla ~/.mozilla

# set mailhog
sudo curl -SL https://github.com/mailhog/MailHog/releases/download/v1.0.1/MailHog_linux_amd64 -o /usr/local/bin/mailhog
sudo chmod +x /usr/local/bin/mailhog
chmod g-w mailhog.service
sudo cp mailhog.service /etc/systemd/system/mailhog.service
sudo systemctl enable --now mailhog

# nodejs & yarn
#curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
#curl -sL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/nodesource.gpg add -
#sudo sh -c 'echo "deb https://deb.nodesource.com/node_16.x $(lsb_release -cs) main" > /etc/apt/sources.list.d/nodesource.list'
#sudo sh -c 'echo "#deb-src https://deb.nodesource.com/node_16.x $(lsb_release -cs) main" >> /etc/apt/sources.list.d/nodesource.list'
#sudo apt update && sudo apt install -y nodejs
#sudo npm install -g yarn
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# apache
./build-apache.sh

# mariadb
./build-mariadb.sh

# dbeaver
curl -sL https://dbeaver.io/debs/dbeaver.gpg.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/dbeaver-ce.gpg add -
sudo sh -c 'echo "deb https://dbeaver.io/debs/dbeaver-ce /" > /etc/apt/sources.list.d/dbeaver-ce.list'
sudo apt update && sudo apt install -y dbeaver-ce

# php
#sudo add-apt-repository -y ppa:ondrej/php
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
curl -SL https://github.com/docker/compose/releases/download/v2.15.1/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose

# spotify
#curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key --keyring /etc/apt/trusted.gpg.d/spotify.gpg add -
#sudo sh -c 'echo "deb http://repository.spotify.com stable non-free" > /etc/apt/sources.list.d/spotify.list'
#sudo apt update && sudo apt install -y spotify-client

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
sed -i 's/XDG_MUSIC_DIR/#XDG_MUSIC_DIR/' ~/.config/user-dirs.dirs
sed -i 's/XDG_VIDEOS_DIR=/#XDG_VIDEOS_DIR=/' ~/.config/user-dirs.dirs

# Oh my zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
