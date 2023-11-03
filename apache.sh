#!/usr/bin/env bash

set -ex

sudo apt update
sudo apt install -y apache2

sudo a2dismod mpm_event
sudo a2enmod mpm_prefork rewrite
echo "ServerName localhost" | sudo tee /etc/apache2/conf-available/fqdn.conf
sudo a2enconf fqdn

sudo sed -i 's#APACHE_RUN_USER=www-data#APACHE_RUN_USER=yvh#g' /etc/apache2/envvars
sudo sed -i 's#APACHE_RUN_GROUP=www-data#APACHE_RUN_GROUP=yvh#g' /etc/apache2/envvars

sudo systemctl restart apache2
