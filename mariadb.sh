#!/usr/bin/env bash

set -ex

sudo curl --silent --show-error --location --output /etc/apt/keyrings/mariadb.pgp "https://mariadb.org/mariadb_release_signing_key.pgp"
echo "X-Repolib-Name: MariaDB
Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/mariadb.pgp
URIs: https://mirrors.xtom.de/mariadb/repo/11.4/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: main" | sudo tee /etc/apt/sources.list.d/mariadb.sources
sudo apt update && sudo apt install --assume-yes mariadb-client

