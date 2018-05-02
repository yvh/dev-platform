#!/bin/bash

set -xe

if [ -z "$1" ]; then
    echo -e "\e[0;31mYou must specify a PHP version\e[0m"
    exit 1
fi

BASEDIR=$(pwd)
VERSION=$1
TINY_VERSION=${VERSION%.*?}
PHP_VERSION="php-$VERSION"
PHP_URL="https://secure.php.net/get/$PHP_VERSION.tar.bz2/from/this/mirror"
PHP_PATH="/usr/local/php/$VERSION"
INI_PATH="/etc/php/$TINY_VERSION"
CONF_PATH="$INI_PATH/conf.d"

sudo -E mkdir -p $PHP_PATH && cd $_
sudo -E curl -SsL $PHP_URL -o $PHP_VERSION.tar.bz2
sudo -E tar -xjf $PHP_VERSION.tar.bz2
sudo -E mv $PHP_VERSION src && cd $_
sudo -E sed -i 's/PHP_EXTRA_VERSION=""/PHP_EXTRA_VERSION="-samtyang"/g' configure
sudo -E ./configure \
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
    CFLAGS="-llber"

sudo -E make -j5 && sudo -E make install
cd $PHP_PATH
sudo -E mkdir apache2
sudo -E cp /usr/lib/apache2/modules/libphp5.so /etc/apache2/mods-available/php5.load $BASEDIR/apache/php5.conf apache2/
sudo -E chmod -x apache2/*
cd bin
sudo -E ./pecl install apcu-4.0.11 xdebug-2.4.1 ZendOpcache-7.0.4
cd ..
sudo -E chmod -x lib/php/20100525/*
sudo -E rm $PHP_VERSION.tar.bz2

if [ ! -d "$INI_PATH" ]; then
    sudo -E mkdir -p $INI_PATH $CONF_PATH
#    sudo -E cp $BASEDIR/ini/php$TINY_VERSION.ini $INI_PATH/php.ini
#    sudo -E cp $BASEDIR/ext/{apcu,xdebug,opcache}.ini $CONF_PATH/
#    sudo -E sed -i "s#zend_extension=xdebug.so#zend_extension=$PHP_PATH/lib/php/20100525/xdebug.so#g" $CONF_PATH/xdebug.ini
#    sudo -E sed -i "s#zend_extension=opcache.so#zend_extension=$PHP_PATH/lib/php/20100525/opcache.so#g" $CONF_PATH/opcache.ini
#    sudo -E chmod -x $INI_PATH/php.ini $CONF_PATH/*
fi

cd $PHP_PATH/..
sudo -E ln -s $PHP_PATH $TINY_VERSION
