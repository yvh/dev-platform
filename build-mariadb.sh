#!/usr/bin/env bash

set -ex

sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
echo "deb [arch=amd64,i386] http://mariadb.mirror.nucleus.be/repo/10.2/ubuntu artful main" | sudo tee /etc/apt/sources.list.d/mariadb.list

# Hack for mariadb 10.2 for Ubuntu 18.04
# @TODO Remove when it's available
echo -e "Package: mariadb*\nPin: release n=artful\nPin-Priority: 1000" | sudo tee /etc/apt/preferences.d/mariadb.pref

sudo apt update
sudo apt install -y mariadb-server mariadb-client

sudo sed -i -e "s|#default-character-set = utf8|default-character-set = utf8|" /etc/mysql/conf.d/mariadb.cnf
sudo sed -i -e "s|#character-set-server\s*= utf8|character-set-server = utf8|" /etc/mysql/conf.d/mariadb.cnf
sudo sed -i -e "s|#collation-server\s*= utf8_general_ci|collation-server = utf8_general_ci|" /etc/mysql/conf.d/mariadb.cnf
sudo sed -i -e "s|#character_set_server\s*= utf8|character_set_server = utf8|" /etc/mysql/conf.d/mariadb.cnf
sudo sed -i -e "s|#collation_server\s*= utf8_general_ci|collation_server = utf8_general_ci|" /etc/mysql/conf.d/mariadb.cnf
sudo sed -i -e "s|max_allowed_packet\s*= 16M|max_allowed_packet = 64M|" /etc/mysql/my.cnf
sudo sed -i -e "s|tmp_table_size\s*= 32M|tmp_table_size = 256M|" /etc/mysql/my.cnf
sudo sed -i -e "s|max_heap_table_size\s*= 32M|max_heap_table_size = 256M|" /etc/mysql/my.cnf
sudo sed -i -e "/max_heap_table_size\s*= 256M/a join_buffer_size = 32M" /etc/mysql/my.cnf
sudo sed -i -e "/join_buffer_size\s*= 32/a table_cache = 2048" /etc/mysql/my.cnf

sudo systemctl restart mariadb

PWD=$(pwd)
cd ~ && mysql_secure_installation
cd $PWD # Reset path

sudo apt install --no-install-recommends mysql-workbench
