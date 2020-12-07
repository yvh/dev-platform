#!/usr/bin/env bash

set -ex

sudo apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
sudo sh -c 'echo "deb [arch=amd64] https://archive.mariadb.org/repo/10.5/ubuntu groovy main" > /etc/apt/sources.list.d/mariadb.list'
sudo sh -c 'echo "deb-src https://archive.mariadb.org/repo/10.5/ubuntu groovy main" >> /etc/apt/sources.list.d/mariadb.list'
sudo apt update && sudo apt install -y mariadb-server mariadb-client
sudo mysql_secure_installation
