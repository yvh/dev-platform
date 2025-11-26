#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo -E bash "$0" "$@"
fi

echo "🐬 Installing MariaDB client..."
mkdir --parents /etc/apt/keyrings
curl --silent --show-error --fail --location --output /etc/apt/keyrings/mariadb-keyring.pgp "https://mariadb.org/mariadb_release_signing_key.pgp"
echo "X-Repolib-Name: MariaDB
Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/mariadb-keyring.pgp
URIs: https://deb.mariadb.org/11.8/debian
Suites: $(lsb_release --codename --short)
Components: main" | tee /etc/apt/sources.list.d/mariadb.sources > /dev/null
apt update && apt install --no-install-recommends --no-install-suggests --assume-yes mariadb-client

echo ""
echo "🔧 Disabling ssl-verify-server-cert..."
cat > /etc/mysql/mariadb.conf.d/70-ssl-verify.cnf  << EOF
[client]
ssl-verify-server-cert = false
EOF
