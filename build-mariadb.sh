#!/usr/bin/env bash

set -ex

sudo apt-key --keyring /etc/apt/trusted.gpg.d/mariadb.gpg adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
sudo sh -c 'echo "deb [arch=amd64] https://mirrors.xtom.nl/mariadb/repo/10.6/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/mariadb.list'
sudo sh -c 'echo "#deb-src https://mirrors.xtom.nl/mariadb/repo/10.6/ubuntu $(lsb_release -cs) main" >> /etc/apt/sources.list.d/mariadb.list'
sudo apt update && sudo apt install -y mariadb-server mariadb-client mariadb-backup
