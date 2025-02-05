#!/usr/bin/env bash

set -ex

sudo apt update
sudo apt install --assume-yes apache2

sudo a2enmod mpm_event rewrite proxy_fcgi setenvif ssl
echo "ServerName localhost" | sudo tee /etc/apache2/conf-available/fqdn.conf
sudo a2enconf fqdn

sudo sed --in-place 's#APACHE_RUN_USER=www-data#APACHE_RUN_USER=yvh#g' /etc/apache2/envvars
sudo sed --in-place 's#APACHE_RUN_GROUP=www-data#APACHE_RUN_GROUP=yvh#g' /etc/apache2/envvars

sudo systemctl restart apache2
