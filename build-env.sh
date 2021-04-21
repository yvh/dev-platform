#!/usr/bin/env bash

set -ex

# /tmp to tmpfs
sudo cp -v /usr/share/systemd/tmp.mount /etc/systemd/system/
sudo systemctl enable --now tmp.mount

# upgrade & install some apps
sudo add-apt-repository -y ppa:libreoffice/ppa
sudo add-apt-repository -y ppa:git-core/ppa

sudo apt -y full-upgrade
sudo apt install -y build-essential apt-transport-https ca-certificates gnupg-agent software-properties-common \
    tlp vim curl subversion git sshfs htop zsh gimp gimp-data-extras libreoffice libreoffice-style-breeze \
    filezilla hunspell-fr hunspell-fr-modern network-manager-fortisslvpn inkscape \
    ttf-bitstream-vera fonts-dejavu fonts-hack fonts-lato fonts-open-sans fonts-roboto fonts-powerline
sudo apt install -y --no-install-recommends kdiff3 wireshark

# github cli
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
sudo sh -c 'echo "deb https://cli.github.com/packages $(lsb_release -cs) main" > /etc/apt/sources.list.d/github.list'
sudo sh -c 'echo "#deb-src https://cli.github.com/packages $(lsb_release -cs) main" >> /etc/apt/sources.list.d/github.list'
sudo apt update && sudo apt install -y gh

# google chrome
curl -SL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /tmp/google-chrome-stable_current_amd64.deb
sudo apt install -y /tmp/google-chrome-stable_current_amd64.deb

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

# remove uneccessary apps
sudo apt-get purge -y fonts-lohit* fonts-tlwg* fonts-samyak* fonts-tibetan-machine fonts-lklug-sinhala nano firefox firefox-locale-en skanlite \
    kio-audiocd
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
curl -sL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/nodesource.gpg add -
sudo sh -c 'echo "deb https://deb.nodesource.com/node_14.x $(lsb_release -cs) main" > /etc/apt/sources.list.d/nodesource.list'
sudo sh -c 'echo "#deb-src https://deb.nodesource.com/node_14.x $(lsb_release -cs) main" >> /etc/apt/sources.list.d/nodesource.list'
sudo apt update && sudo apt install -y nodejs
sudo npm install -g yarn

# apache
./build-apache.sh

# mariadb
./build-mariadb.sh

#sudo add-apt-repository -y ppa:serge-rider/dbeaver-ce
#sudo apt update && sudo apt install -y dbeaver-ce

# php
sudo add-apt-repository -y ppa:ondrej/php
./build-php.sh
sudo mkdir -p /var/www/html/phpinfo
sudo sh -c 'echo "<?php phpinfo();" > /var/www/html/phpinfo/index.php'

# docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key --keyring /etc/apt/trusted.gpg.d/docker.gpg add -
sudo sh -c 'echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list'
sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker yvh

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# spotify
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key --keyring /etc/apt/trusted.gpg.d/spotify.gpg add -
sudo sh -c 'echo "deb http://repository.spotify.com stable non-free" > /etc/apt/sources.list.d/spotify.list'
sudo apt update && sudo apt install -y spotify-client

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
