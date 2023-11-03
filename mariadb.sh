#!/usr/bin/env bash

set -ex

sudo curl -o /etc/apt/keyrings/mariadb.pgp 'https://mariadb.org/mariadb_release_signing_key.pgp'
echo "X-Repolib-Name: MariaDB
Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/mariadb.pgp
URIs: https://mariadb.mirror.wearetriple.com/repo/10.11/ubuntu
Suites: $(lsb_release -cs)
Components: main main/debug" | sudo tee /etc/apt/sources.list.d/mariadb.sources
sudo apt update && sudo apt install -y mariadb-server mariadb-client mariadb-backup
