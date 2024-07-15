#!/usr/bin/env bash

set -ex

# /tmp to tmpfs
sudo cp /usr/share/systemd/tmp.mount /etc/systemd/system/
sudo systemctl enable --now tmp.mount

# remove preinstalled-pool
sudo rm --recursive --force /var/lib/preinstalled-pool
sudo rm --force /etc/apt/sources.list.d/preinstalled-pool.list
sudo rm --force /etc/apt/trusted.gpg

# upgrade & install some apps
sudo apt update && sudo apt full-upgrade --assume-yes
sudo apt install --assume-yes build-essential apt-transport-https ca-certificates gnupg-agent software-properties-common \
    vim curl sshfs htop zsh gimp gimp-data-extras filezilla inkscape git-flow \
    ttf-bitstream-vera fonts-dejavu fonts-hack fonts-lato fonts-open-sans fonts-roboto fonts-powerline vlc \
    ttf-mscorefonts-installer hunspell-fr cntlm openssh-server jq network-manager-fortisslvpn imagemagick \
    kompare
sudo apt install --assume-yes --no-install-recommends kdiff3 wireshark

# libreoffice
./libreoffice.sh

# remmina
./remmina.sh

# google chrome
./google-chrome.sh

# visual studio code
./visual-studio-code.sh

# pdfsam
./pdfsam.sh

# postman
./postman.sh

# falco
./falco.sh

# jetbrains-toolbox
./jetbrains-toolbox.sh

# customization
sudo update-alternatives --set editor /usr/bin/vim.basic
sudo sed --in-place 's/#force_color_prompt=yes/force_color_prompt=yes/' /root/.bashrc
sudo sed --in-place 's/01;32m/01;31m/' /root/.bashrc
sudo sed --in-place 's/    SendEnv/#   SendEnv/g' /etc/ssh/ssh_config
sudo sed --in-place 's/#GatewayPorts no/GatewayPorts yes/g' /etc/ssh/sshd_config
sudo sed --in-place '/disable ghostscript format types/,+6d' /etc/ImageMagick-6/policy.xml
sudo sh -c 'echo "[connectivity]
enabled=false" > /etc/NetworkManager/conf.d/20-connectivity.conf'

# remove uneccessary apps
sudo apt-get purge --assume-yes fonts-lohit* fonts-tlwg* fonts-samyak* fonts-tibetan-machine fonts-lklug-sinhala nano \
    firefox firefox-locale-en skanlite kio-audiocd thunderbird muon kde-config-tablet usb-creator-kde snapd \
    plasma-welcome partitionmanager
sudo apt autoremove --purge --assume-yes
rm --recursive --force ~/.cache/mozilla ~/.mozilla ~/.config/plasma-welcomerc ~/.config/KDE/UserFeedback.org.kde.plasma-welcome.conf

# oc
./oc.sh

# apache
./apache.sh

# mariadb
./mariadb.sh

# php
./php.sh

# nodejs & yarn
./nvm.sh

# msmtp
./msmtp.sh

# docker
./docker.sh

# change inotify for idea (phpstorm)
sudo sh -c 'echo "fs.inotify.max_user_watches = 524288" > /etc/sysctl.d/10-idea.conf'
sudo sysctl --load --system

# full-upgrade
sudo apt full-upgrade --assume-yes

sudo apt autoremove --purge --assume-yes

# remove uneccessary dirs
echo "enabled=False" > ~/.config/user-dirs.conf
sed -i 's/XDG_TEMPLATES_DIR/#XDG_TEMPLATES_DIR/' ~/.config/user-dirs.dirs
sed -i 's/XDG_PUBLICSHARE_DIR/#XDG_PUBLICSHARE_DIR/' ~/.config/user-dirs.dirs
sed -i 's/XDG_DOCUMENTS_DIR/#XDG_DOCUMENTS_DIR/' ~/.config/user-dirs.dirs
sed -i 's/XDG_MUSIC_DIR/#XDG_MUSIC_DIR/' ~/.config/user-dirs.dirs
sed -i 's/XDG_VIDEOS_DIR=/#XDG_VIDEOS_DIR=/' ~/.config/user-dirs.dirs

# Oh my zsh
sh -c "$(curl --silent --show-error --location https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
