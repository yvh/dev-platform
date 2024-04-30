#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
    echo "usage: mariadb-create-db-user username <password>"
    exit 1
fi

PASSWORD=$2
if [ -z "$2" ]; then
  PASSWORD=$(openssl rand -base64 8)
fi

sudo mariadb <<MARIADB_SCRIPT
CREATE DATABASE $1;
CREATE USER $1@localhost IDENTIFIED BY '$PASSWORD';
GRANT ALL PRIVILEGES ON $1.* TO $1@localhost;
FLUSH PRIVILEGES;
MARIADB_SCRIPT

echo -e "\e[0;32mMariaDB database and user created\e[0m"
echo "Database: $1"
echo "Username: $1"
echo "Password: $PASSWORD"
