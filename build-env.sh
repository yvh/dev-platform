#!/usr/bin/env bash

set -ex

# Upgrade & install some apps
# sudo add-apt-repository -y ppa:linrunner/tlp
sudo add-apt-repository -y ppa:webupd8team/java
sudo add-apt-repository -y ppa:otto-kesselgulasch/gimp
sudo add-apt-repository -y ppa:libreoffice/ppa
sudo add-apt-repository -y ppa:git-core/ppa
# sudo add-apt-repository -y ppa:remmina-ppa-team/remmina-next
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt -y full-upgrade
#sudo apt install --no-install-recommends tlp tlp-rdw ethtool smartmontools linux-tools-generic
sudo apt install -y open-vm-tools-desktop vim curl ubuntu-restricted-extras \
    oracle-java8-installer oracle-java8-set-default subversion git sshfs htop \
    zsh nodejs yarn gimp gimp-data-extras libreoffice libreoffice-style-breeze \
    gnome-tweak-tool
sudo apt install --no-install-recommends kdiff3-qt wireshark

sudo update-alternatives --set editor /usr/bin/vim.basic
sudo sed -i 's/01;32m/01;31m/' /root/.bashrc
echo 'yannick ALL=(ALL:ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/users

sudo apt purge -y fonts-lohit* fonts-tlwg* fonts-samyak* fonts-tibetan-machine \
    fonts-lklug-sinhala nano

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

curl -fsSL https://atom.io/download/deb -o ~/Downloads/atom.deb
sudo apt install -y ~/Downloads/atom.deb
rm ~/Downloads/atom.deb
