#!/usr/bin/env bash

set -ex

sudo apt-key --keyring /etc/apt/trusted.gpg.d/mariadb.gpg adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
sudo sh -c 'echo "deb [arch=amd64] http://ams2.mirrors.digitalocean.com/mariadb/repo/10.5/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/mariadb.list'
sudo sh -c 'echo "#deb-src http://ams2.mirrors.digitalocean.com/mariadb/repo/10.5/ubuntu $(lsb_release -cs) main" >> /etc/apt/sources.list.d/mariadb.list'
sudo apt update && sudo apt install -y mariadb-server mariadb-client
