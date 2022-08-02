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

function usage
{
    echo "usage: php-switch [-a] | [-c] | [-h] | [-r] phpversion"
}

cli=1
apache2=1
restart=1

while getopts "achr" opt; do
  case $opt in
    a)
        # Just apache2
        cli=0
        ;;
    c)
        # Just cli
        apache2=0
        restart=0
        ;;
    h)
        usage
        exit
        ;;
    r)
        restart=0
        ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
  esac
done
shift $((OPTIND-1)) # remove parsed options and args from $@ list

php_version=$1

if ! command -v php$php_version &> /dev/null; then
    echo -e "\e[0;31mPHP version $php_version not exist!\e[0m"
    exit 1
fi

if [ $cli = 1 ]; then
    echo -e "\e[0;32mSwtiching to PHP version $php_version\e[0m"
    update-alternatives --set php /usr/bin/php$php_version
    update-alternatives --set php-config /usr/bin/php-config$php_version
    update-alternatives --set phpize /usr/bin/phpize$php_version
    update-alternatives --set phar /usr/bin/phar$php_version
    update-alternatives --set phar.phar /usr/bin/phar.phar$php_version
fi

if [ $apache2 = 1 ]; then
    echo -e "\e[0;32mSwitching apache2 module to PHP version $php_version\e[0m"
    module=$(find /etc/apache2/mods-enabled -name "php*.load" -exec basename {} \;)

    if [ -n "$module" ]; then
        sudo a2dismod ${module%.*}
    fi

    sudo a2enmod php$php_version
fi

if [ $restart = 1 ]; then
    echo -e "\e[0;32mapache2 restarted!\e[0m"
    systemctl restart apache2
fi

