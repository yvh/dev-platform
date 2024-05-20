#!/usr/bin/env bash

set -ex

curl --silent --show-error --location "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x14aa40ec0831756756d7f66c4f4ea0aae5267a6c" | sudo gpg --dearmor --output /etc/apt/keyrings/php.gpg
echo "Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/php.gpg
URIs: https://ppa.launchpadcontent.net/ondrej/php/ubuntu
Suites: $(lsb_release --codename --short)
Components: main" | sudo tee /etc/apt/sources.list.d/php.sources
sudo apt update

./php-install.sh 8.1
./php-install.sh 8.2
./php-install.sh 8.3

sudo cp php-switch.sh /usr/local/bin/php-switch
sudo mkdir --parents /var/www/html/phpinfo
sudo sh -c 'echo "<?php phpinfo();" > /var/www/html/phpinfo/index.php'
curl --silent --show-error --location "https://raw.githubusercontent.com/composer/getcomposer.org/main/web/installer" | sudo php -- --install-dir=/usr/local/bin --filename=composer
