#!/usr/bin/env bash

set -ex

curl --silent --show-error --location "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x14aa40ec0831756756d7f66c4f4ea0aae5267a6c" | sudo gpg --dearmor --output /etc/apt/keyrings/php.gpg
echo "Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/php.gpg
URIs: https://ppa.launchpadcontent.net/ondrej/php/ubuntu
Suites: $(lsb_release --codename --short)
Components: main" | sudo tee /etc/apt/sources.list.d/php.sources
sudo apt update

for VERSION in 7.4 8.0 8.1 8.2; do
    sudo apt install --assume-yes php${VERSION} php${VERSION}-{apcu,ast,bz2,cli,curl,dev,gd,intl,ldap,mbstring,mysql,opcache,soap,solr,ssh2,readline,redis,xml,xsl,xdebug,zip}

    for SYSTEM in apache2 cli; do
        ini_path=/etc/php/${VERSION}/${SYSTEM}
        sudo sed --in-place "s|max_execution_time = 30|max_execution_time = 60|" $ini_path/php.ini
        sudo sed --in-place "s|memory_limit = 128M|memory_limit = 512M|" $ini_path/php.ini
        sudo sed --in-place "s|post_max_size = 8M|post_max_size = 55M|" $ini_path/php.ini
        sudo sed --in-place "s|upload_max_filesize = 2M|upload_max_filesize = 50M|" $ini_path/php.ini
        sudo sed --in-place "s|;date.timezone =|date.timezone = Europe/Brussels|" $ini_path/php.ini
        sudo sed --in-place "s|;cgi.fix_pathinfo=1|cgi.fix_pathinfo = 0|" $ini_path/php.ini
        sudo sed --in-place "s|;realpath_cache_ttl = 120|realpath_cache_ttl = 600|" $ini_path/php.ini
        sudo sed --in-place "s|;realpath_cache_size = 4096k|realpath_cache_size = 4096K|" $ini_path/php.ini
    done

    ini_path=/etc/php/${VERSION}/mods-available
    sudo sh -c "echo \"apc.enabled=1\" >> $ini_path/apcu.ini"
    sudo sh -c "echo \"apc.shm_segments=1\" >> $ini_path/apcu.ini"
    sudo sh -c "echo \"apc.shm_size=128M\" >> $ini_path/apcu.ini"
    sudo sh -c "echo \"apc.ttl=7200\" >> $ini_path/apcu.ini"
    sudo sh -c "echo \"apc.enable_cli=0\" >> $ini_path/apcu.ini"

    sudo sh -c "echo \"opcache.enable=1\" >> $ini_path/opcache.ini"
    sudo sh -c "echo \"opcache.enable_cli=1\" >> $ini_path/opcache.ini"
    sudo sh -c "echo \"opcache.revalidate_freq=2\" >> $ini_path/opcache.ini"
    sudo sh -c "echo \"opcache.validate_timestamps=1\" >> $ini_path/opcache.ini"
    sudo sh -c "echo \"opcache.interned_strings_buffer=16\" >> $ini_path/opcache.ini"
    sudo sh -c "echo \"opcache.max_accelerated_files = 20000\" >> $ini_path/opcache.ini"

    sudo sed --in-place 's|zend_extension|;zend_extension|' $ini_path/xdebug.ini
    sudo sh -c "echo \"xdebug.default_enable=1\" >> $ini_path/xdebug.ini"
    sudo sh -c "echo \"xdebug.profiler_enable=0\" >> $ini_path/xdebug.ini"
    sudo sh -c "echo \"xdebug.idekey=PHPSTORM\" >> $ini_path/xdebug.ini"
    sudo sh -c "echo \"xdebug.max_nesting_level=200\" >> $ini_path/xdebug.ini"
    sudo sh -c "echo \"xdebug.remote_enable=1\" >> $ini_path/xdebug.ini"
    sudo sh -c "echo \"xdebug.remote_autostart=0\" >> $ini_path/xdebug.ini"
done

sudo cp php-switch.sh /usr/local/bin/php-switch
sudo mkdir --parents /var/www/html/phpinfo
sudo sh -c 'echo "<?php phpinfo();" > /var/www/html/phpinfo/index.php'
curl --silent --show-error --location "https://raw.githubusercontent.com/composer/getcomposer.org/main/web/installer" | sudo php -- --install-dir=/usr/local/bin --filename=composer
