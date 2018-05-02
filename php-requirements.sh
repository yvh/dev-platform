#!/usr/bin/env bash

set -xe

sudo apt update
sudo apt install -y build-essential \
    autoconf \
    file \
    g++ \
    gcc \
    libc6-dev \
    make \
    pkg-config \
    re2c \
    ca-certificates \
    curl \
    librecode0 \
    default-libmysqlclient-dev \
    libsqlite3-0 \
    libxml2 \
    xz-utils \
    libicu60 \
    libbz2-1.0 \
    libxslt1.1 \
    apache2 \
    libcurl4-openssl-dev \
    libreadline-dev \
    libedit-dev \
    librecode-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    libicu-dev \
    libbz2-dev \
    libxslt1-dev \
    apache2-dev \
    libfreetype6 \
    libjpeg62 \
    libpng16-16 \
    libfreetype6-dev \
    libjpeg-dev \
    libpng-dev \
    libldap2-dev \
    libsasl2-dev

sudo ln -sf /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib
sudo ln -sf /usr/include/x86_64-linux-gnu/curl /usr/include/curl

sudo sh -c "cat > /etc/apache2/conf-available/php.conf << EOF
<FilesMatch \.php$>
    SetHandler application/x-httpd-php
</FilesMatch>

DirectoryIndex disabled
DirectoryIndex index.php index.html
EOF"
sudo a2enconf php

sudo systemctl restart apache2

# Create phpinfo
sudo mkdir -p /var/www/html/phpinfo
sudo echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/phpinfo/index.php
