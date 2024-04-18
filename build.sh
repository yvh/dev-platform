#!/usr/bin/env bash

set -ex

# /tmp to tmpfs
sudo cp /usr/share/systemd/tmp.mount /etc/systemd/system/
sudo systemctl enable --now tmp.mount

# upgrade & install some apps
sudo apt update && sudo apt full-upgrade --assume-yes
sudo apt install --assume-yes build-essential apt-transport-https ca-certificates gnupg-agent software-properties-common \
    vim curl sshfs htop zsh filezilla git-flow cntlm jq terminator \
    ttf-bitstream-vera fonts-dejavu fonts-hack fonts-lato fonts-open-sans fonts-roboto fonts-powerline \
    aspell-fr hyphen-fr mythes-fr hunspell-fr ttf-mscorefonts-installer network-manager-fortisslvpn-gnome
sudo apt install --assume-yes --no-install-recommends kdiff3 wireshark

# remove snapd
sudo snap remove firefox gnome-42-2204
sudo snap remove gtk-common-themes
sudo snap remove snapd-desktop-integration
sudo snap remove snap-store
sudo snap remove firmware-updater
sudo snap remove core22
sudo snap remove bare
sudo snap remove snapd
sudo apt -y autoremove --purge snapd
rm -rf ~/snap ~/Downloads/firefox.tmp

# libreoffice
./libreoffice.sh

# google chrome
./google-chrome.sh

# visual studio code
./visual-studio-code.sh

# postman
./postman.sh

# jetbrains-toolbox
./jetbrains-toolbox.sh

# customization
sudo update-alternatives --set editor /usr/bin/vim.basic
sudo sed --in-place 's/#force_color_prompt=yes/force_color_prompt=yes/' /root/.bashrc
sudo sed --in-place 's/01;32m/01;31m/' /root/.bashrc
sudo sed --in-place 's/    SendEnv/#   SendEnv/g' /etc/ssh/ssh_config

# remove uneccessary apps
sudo apt-get purge --assume-yes fonts-lohit* fonts-tlwg* fonts-samyak* fonts-tibetan-machine fonts-lklug-sinhala nano \
    firefox firefox-locale-en skanlite kio-audiocd thunderbird
sudo apt autoremove --purge --assume-yes
rm --recursive --force ~/.cache/mozilla ~/.mozilla

# oc
./oc.sh

# dnsmasq
./dnsmasq.sh

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
sed -i 's/XDG_PICTURES_DIR/#XDG_PICTURES_DIR/' ~/.config/user-dirs.dirs
sed -i 's/XDG_VIDEOS_DIR=/#XDG_VIDEOS_DIR=/' ~/.config/user-dirs.dirs

# Oh my zsh
sh -c "$(curl --silent --show-error --location https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
