#!/usr/bin/env bash

set -xe

if [ -z "$1" ]; then
    echo -e "\e[0;31mYou must specify a PHP version\e[0m"
    exit 1
fi

BASEDIR=$(pwd)
VERSION=$1
TINY_VERSION=${VERSION%.*?}
PHP_VERSION="php-$VERSION"
PHP_URL="https://secure.php.net/get/$PHP_VERSION.tar.xz/from/this/mirror"
PHP_PATH="/usr/local/php/$VERSION"
INI_PATH="/etc/php/$TINY_VERSION"
CONF_PATH="$INI_PATH/conf.d"

sudo mkdir -p $PHP_PATH && cd $_
sudo curl -SsL $PHP_URL -o $PHP_VERSION.tar.xz
sudo tar -xJf $PHP_VERSION.tar.xz
sudo mv $PHP_VERSION src && cd $_
sudo sed -i 's/PHP_EXTRA_VERSION=""/PHP_EXTRA_VERSION="-custom"/g' configure
sudo ./configure \
    --prefix=/usr/local/php/$VERSION \
    --sbindir=/usr/local/php/$VERSION \
    --sysconfdir=/usr/local/php/$VERSION \
    --build=x86_64-linux-gnu \
    --host=x86_64-linux-gnu \
    --with-layout=GNU \
    --with-config-file-path=$INI_PATH \
    --with-config-file-scan-dir=$CONF_PATH \
    --disable-cgi \
    --with-readline \
    --disable-pcntl \
    --enable-cli \
    --with-apxs2=/usr/bin/apxs2 \
    --with-pear \
    --with-xmlrpc \
    --enable-mbstring \
    --enable-mbregex \
    --enable-phar \
    --enable-posix \
    --enable-soap \
    --enable-sockets \
    --enable-zip \
    --enable-intl \
    --with-ldap \
    --with-ldap-sasl=/usr \
    --with-kerberos \
    --with-icu-dir=/usr \
    --with-curl=/usr/bin \
    --with-gd \
    --with-jpeg-dir=/usr \
    --with-png-dir=shared,/usr \
    --enable-gd-native-ttf \
    --with-bz2=/usr \
    --with-gettext \
    --with-iconv \
    --with-mhash \
    --with-zlib-dir=/usr \
    --with-regex=php \
    --with-openssl \
    --with-openssl-dir=/usr/bin \
    --with-mysqli=mysqlnd \
    --with-sqlite3=/usr \
    --enable-pdo \
    --with-pdo-mysql=mysqlnd \
    --with-pdo-sqlite=/usr \
    --with-libedit \
    --enable-dom \
    --enable-json \
    --enable-simplexml \
    --enable-xml \
    --enable-ctype \
    --enable-tokenizer \
    --enable-libxml \
    --with-xsl \
    --enable-exif \
    --enable-dba \
    --enable-ftp \
    --enable-shmop \
    --enable-fileinfo \
    --enable-filter \
    --without-mm \
    --with-pic \
    --enable-bcmath \
    --enable-zend-signals \
    --enable-opcache \
    CFLAGS="-llber"

sudo make -j5 && sudo make install
cd $PHP_PATH
sudo mkdir apache2
sudo a2dismod php5
sudo cp /usr/lib/apache2/modules/libphp5.so /etc/apache2/mods-available/php5.load apache2/
sudo rm /usr/lib/apache2/modules/libphp5.so /etc/apache2/mods-available/php5.load
sudo chmod -x apache2/*
sudo ./bin/pecl install apcu-4.0.11 xdebug-2.5.1
sudo chmod -x lib/php/20131226/*
sudo rm $PHP_VERSION.tar.xz

if [ ! -d "$INI_PATH" ]; then
    sudo mkdir -p $INI_PATH $CONF_PATH

    sudo cp $PHP_PATH/src/php.ini-development $INI_PATH/php.ini
    cd $INI_PATH
    sudo sed -i -e "s|max_execution_time = 30|max_execution_time = 60|" php.ini
    sudo sed -i -e "s|memory_limit = 128M|memory_limit = 512M|" php.ini
    sudo sed -i -e "s|post_max_size = 8M|post_max_size = 55M|" php.ini
    sudo sed -i -e "s|upload_max_filesize = 2M|upload_max_filesize = 50M|" php.ini
    sudo sed -i -e "s|;date.timezone =|date.timezone = Europe/Brussels|" php.ini
    sudo sed -i -e "s|;cgi.fix_pathinfo=1|cgi.fix_pathinfo = 0|" php.ini
    sudo sed -i -e "s|;realpath_cache_size = 16k|realpath_cache_size = 4096K|" php.ini
    sudo sed -i -e "s|;realpath_cache_ttl = 120|realpath_cache_ttl = 600|" php.ini
    sudo sed -i -e "s|\(mysqli\?.default_socket\)\s*=|\1 = /var/run/mysqld/mysqld.sock|" php.ini

    sudo sh -c "cat > $CONF_PATH/apcu.ini << EOF
[apcu]
extension=\"apcu.so\"
apc.enabled=1
apc.shm_segments=1
apc.shm_size=128M
apc.ttl=7200
apc.enable_cli=0
EOF"

    sudo sh -c "cat > $CONF_PATH/opcache.ini << EOF
[opcache]
zend_extension=\"/usr/local/php/5.6/lib/php/20131226/opcache.so\"
opcache.enable=1
opcache.enable_cli=1
opcache.memory_consumption=128
opcache.interned_strings_buffer=8
opcache.fast_shutdown=1
opcache.revalidate_freq=0
opcache.max_accelerated_files = 20000
EOF"

    sudo sh -c "cat > $CONF_PATH/xdebug.ini << EOF
[xdebug]
zend_extension=\"/usr/local/php/5.6/lib/php/20131226/xdebug.so\"
xdebug.default_enable=1
xdebug.profiler_enable=0
xdebug.idekey=PHPSTORM
xdebug.max_nesting_level=200
xdebug.remote_enable=1
xdebug.remote_autostart=0
EOF"
fi

cd $PHP_PATH/..
sudo ln -sfn $PHP_PATH $TINY_VERSION
