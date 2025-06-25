#!/usr/bin/env bash

echo "🐬 Installing MariaDB client..."

sudo curl --silent --show-error --fail --location --output /etc/apt/keyrings/mariadb.pgp "https://mariadb.org/mariadb_release_signing_key.pgp"
echo "X-Repolib-Name: MariaDB
Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/mariadb.pgp
URIs: https://mirrors.xtom.nl/mariadb/repo/11.4/ubuntu
Suites: $(lsb_release --codename --short)
Components: main main/debug" | sudo tee /etc/apt/sources.list.d/mariadb.sources
sudo apt update && sudo apt install --assume-yes mariadb-client

