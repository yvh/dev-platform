#!/usr/bin/env bash

set -ex

# Upgrade & install some apps
sudo add-apt-repository -y ppa:libreoffice/ppa
sudo add-apt-repository -y ppa:git-core/ppa
sudo add-apt-repository -y ppa:remmina-ppa-team/remmina-next
#curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
#curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
#echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt -y full-upgrade
sudo apt install -y tlp open-vm-tools-desktop vim curl ubuntu-restricted-extras \
    subversion git sshfs htop zsh gimp gimp-data-extras libreoffice libreoffice-style-breeze \
    gnome-tweak-tool
sudo apt install --no-install-recommends kdiff3 wireshark

sudo update-alternatives --set editor /usr/bin/vim.basic
sudo sed -i 's/01;32m/01;31m/' /root/.bashrc
#echo 'yannick ALL=(ALL:ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/users

sudo apt-get purge -y fonts-lohit* fonts-tlwg* fonts-samyak* fonts-tibetan-machine fonts-lklug-sinhala nano

# Oh my zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# atom
wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
sudo apt update && sudo apt install -y atom

# nodejs & yarn
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g yarn

# apache
sudo apt install -y apache2

sudo a2dismod mpm_event
sudo a2enmod mpm_prefork rewrite
echo "ServerName localhost" | sudo tee /etc/apache2/conf-available/fqdn.conf
sudo a2enconf fqdn

sudo sed -i 's#APACHE_RUN_USER=www-data#APACHE_RUN_USER=yvh#g' /etc/apache2/envvars
sudo sed -i 's#APACHE_RUN_GROUP=www-data#APACHE_RUN_GROUP=yvh#g' /etc/apache2/envvars

sudo systemctl restart apache2

# mariadb
sudo apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
sudo sh -c 'echo "deb [arch=amd64] http://mariadb.mirror.nucleus.be/repo/10.5/ubuntu focal main" > /etc/apt/sources.list.d/mariadb.list'
sudo apt update && sudo apt install -y mariadb-server mariadb-client
sudo mysql_secure_installation
