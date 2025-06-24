#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    exit
fi

curl --silent --show-error --location --output /etc/apt/keyrings/mariadb.pgp "https://mariadb.org/mariadb_release_signing_key.pgp"
echo "X-Repolib-Name: MariaDB
Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/mariadb.pgp
URIs: https://mirrors.xtom.de/mariadb/repo/11.4/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: main" | tee /etc/apt/sources.list.d/mariadb.sources
apt update && apt install --assume-yes mariadb-client
