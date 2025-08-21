#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo bash "$0" "$@"
fi

echo "🐬 Installing MariaDB client..."
#curl --silent --show-error --fail --location --output /etc/apt/keyrings/mariadb.pgp "https://mariadb.org/mariadb_release_signing_key.pgp"
#echo "X-Repolib-Name: MariaDB
#Types: deb
#Architectures: amd64
#Signed-By: /etc/apt/keyrings/mariadb.pgp
#URIs: https://mirrors.xtom.de/mariadb/repo/11.4/debian
#Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
#Components: main" | tee /etc/apt/sources.list.d/mariadb.sources > /dev/null
apt update && apt install --no-install-recommends --no-install-suggests --assume-yes mariadb-client
