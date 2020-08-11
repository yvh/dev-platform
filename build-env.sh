#!/usr/bin/env bash

set -ex

# Upgrade & install some apps
sudo add-apt-repository -y ppa:libreoffice/ppa
sudo add-apt-repository -y ppa:git-core/ppa
sudo add-apt-repository -y ppa:remmina-ppa-team/remmina-next

sudo apt -y full-upgrade
sudo apt install -y tlp open-vm-tools-desktop vim curl ubuntu-restricted-extras \
    subversion git sshfs htop zsh gimp gimp-data-extras libreoffice libreoffice-style-breeze \
    gnome-tweak-tool
sudo apt install --no-install-recommends kdiff3 wireshark

sudo update-alternatives --set editor /usr/bin/vim.basic
sudo sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' /root/.bashrc
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

sudo add-apt-repository ppa:serge-rider/dbeaver-ce
sudo apt update && sudo apt install -y dbeaver-ce

# php
sudo add-apt-repository ppa:ondrej/php
for VERSION in 5.6 7.0 7.1 7.2 7.3 7.4;do
    sudo apt install php${VERSION} php${VERSION}-bz2 php${VERSION}-cli php${VERSION}-curl php${VERSION}-gd php${VERSION}-intl php${VERSION}-json php${VERSION}-ldap php${VERSION}-mbstring php${VERSION}-mysql php${VERSION}-opcache php${VERSION}-readline php${VERSION}-xml php${VERSION}-xsl php${VERSION}-zip
done
sudo apt install php-apcu php-xdebug

sudo su
cd /etc/php/{PHP_VERSION}/apache2 # Idem for {PHP_VERSION}/cli
sed -i -e "s|max_execution_time = 30|max_execution_time = 60|" php.ini; \
sed -i -e "s|memory_limit = 128M|memory_limit = 512M|" php.ini; \
sed -i -e "s|post_max_size = 8M|post_max_size = 55M|" php.ini; \
sed -i -e "s|upload_max_filesize = 2M|upload_max_filesize = 50M|" php.ini; \
sed -i -e "s|;date.timezone =|date.timezone = Europe/Brussels|" php.ini; \
sed -i -e "s|;cgi.fix_pathinfo=1|cgi.fix_pathinfo = 0|" php.ini; \
sed -i -e "s|;realpath_cache_size = 4096k|realpath_cache_size = 4096K|" php.ini; \
sed -i -e "s|;realpath_cache_ttl = 120|realpath_cache_ttl = 600|" php.ini

# php 5.6
sed -i -e "s|;realpath_cache_size = 16k|realpath_cache_size = 4096K|" php.inipath

cd /etc/php/{PHP_VERSION}/mods-available
echo "apc.enabled=1" >> apcu.ini; \
echo "apc.shm_segments=1" >> apcu.ini; \
echo "apc.shm_size=128M" >> apcu.ini; \
echo "apc.ttl=7200" >> apcu.ini; \
echo "apc.enable_cli=0" >> apcu.ini

echo "opcache.enable=1" >> opcache.ini; \
echo "opcache.enable_cli=1" >> opcache.ini; \
echo "opcache.revalidate_freq=2" >> opcache.ini; \
echo "opcache.validate_timestamps=1" >> opcache.ini; \
echo "opcache.interned_strings_buffer=16" >> opcache.ini; \
echo "opcache.max_accelerated_files = 20000" >> opcache.ini

sed -i -e "s|zend_extension|;zend_extension|" xdebug.ini; \
echo "xdebug.default_enable=1" >> xdebug.ini; \
echo "xdebug.profiler_enable=0" >> xdebug.ini; \
echo "xdebug.idekey=PHPSTORM" >> xdebug.ini; \
echo "xdebug.max_nesting_level=200" >> xdebug.ini; \
echo "xdebug.remote_enable=1" >> xdebug.ini; \
echo "xdebug.remote_autostart=0" >> xdebug.ini

# docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker your-user
