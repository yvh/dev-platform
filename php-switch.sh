#!/usr/bin/env bash

set -e

err_report() {
    echo "Error on line $1"
    exit 1
}

trap 'err_report $LINENO' ERR

if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    exit
fi

php_version=$1

if ! command -v php$php_version &> /dev/null; then
    echo -e "\e[0;31mPHP version $php_version not exist!\e[0m"
    exit 1
fi

echo -e "\e[0;32mSwtiching to PHP version $php_version\e[0m"
update-alternatives --set php /usr/bin/php$php_version
update-alternatives --set php-config /usr/bin/php-config$php_version
update-alternatives --set phpize /usr/bin/phpize$php_version
update-alternatives --set phar /usr/bin/phar$php_version
update-alternatives --set phar.phar /usr/bin/phar.phar$php_version
