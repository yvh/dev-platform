#!/usr/bin/env bash

set -ex

sudo apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
sudo sh -c 'echo "deb [arch=amd64] http://mariadb.mirror.nucleus.be/repo/10.5/ubuntu focal main" > /etc/apt/sources.list.d/mariadb.list'
sudo apt update && sudo apt install -y mariadb-server mariadb-client
sudo mysql_secure_installation
