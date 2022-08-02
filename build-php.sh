#!/usr/bin/env bash

set -ex

for VERSION in 7.3 7.4 8.0 8.1; do
    sudo apt install -y php${VERSION} php${VERSION}-{bz2,cli,curl,dev,gd,intl,ldap,mbstring,mysql,opcache,soap,readline,xml,xsl,zip}

    for SYSTEM in apache2 cli; do
        ini_path=/etc/php/${VERSION}/${SYSTEM}
        sudo sed -i -e "s|max_execution_time = 30|max_execution_time = 60|" $ini_path/php.ini
        sudo sed -i -e "s|memory_limit = 128M|memory_limit = 512M|" $ini_path/php.ini
        sudo sed -i -e "s|post_max_size = 8M|post_max_size = 55M|" $ini_path/php.ini
        sudo sed -i -e "s|upload_max_filesize = 2M|upload_max_filesize = 50M|" $ini_path/php.ini
        sudo sed -i -e "s|;date.timezone =|date.timezone = Europe/Brussels|" $ini_path/php.ini
        sudo sed -i -e "s|;cgi.fix_pathinfo=1|cgi.fix_pathinfo = 0|" $ini_path/php.ini
        sudo sed -i -e "s|;realpath_cache_ttl = 120|realpath_cache_ttl = 600|" $ini_path/php.ini
        sudo sed -i -e "s|;realpath_cache_size = 4096k|realpath_cache_size = 4096K|" $ini_path/php.ini
        sudo sed -i -e "s|;sendmail_path =|sendmail_path = /usr/bin/msmtp -t|" $ini_path/php.ini
    done
done

sudo apt install -y php-pear libssh2-1-dev
sudo pecl channel-update pecl.php.net

for VERSION in 7.3 7.4 8.0 8.1; do
    sudo update-alternatives --set php /usr/bin/php${VERSION}
    sudo update-alternatives --set php-config /usr/bin/php-config${VERSION}
    sudo update-alternatives --set phpize /usr/bin/phpize${VERSION}
    sudo update-alternatives --set phar /usr/bin/phar${VERSION}
    sudo update-alternatives --set phar.phar /usr/bin/phar.phar${VERSION}

    sudo pecl -d php_suffix=${VERSION} install apcu ast ssh2-1.3.1 xdebug && sudo pecl uninstall -r apcu ast ssh2 xdebug

    ini_path=/etc/php/${VERSION}/mods-available
    sudo sh -c "echo \"extension=apcu.so\" > $ini_path/apcu.ini"
    sudo sh -c "echo \"apc.enabled=1\" >> $ini_path/apcu.ini"
    sudo sh -c "echo \"apc.shm_segments=1\" >> $ini_path/apcu.ini"
    sudo sh -c "echo \"apc.shm_size=128M\" >> $ini_path/apcu.ini"
    sudo sh -c "echo \"apc.ttl=7200\" >> $ini_path/apcu.ini"
    sudo sh -c "echo \"apc.enable_cli=0\" >> $ini_path/apcu.ini"

    sudo sh -c "echo \"extension=ast.so\" > $ini_path/ast.ini"

    sudo sh -c "echo \"extension=ssh2.so\" > $ini_path/ssh2.ini"

    sudo sh -c "echo \"opcache.enable=1\" >> $ini_path/opcache.ini"
    sudo sh -c "echo \"opcache.enable_cli=1\" >> $ini_path/opcache.ini"
    sudo sh -c "echo \"opcache.revalidate_freq=2\" >> $ini_path/opcache.ini"
    sudo sh -c "echo \"opcache.validate_timestamps=1\" >> $ini_path/opcache.ini"
    sudo sh -c "echo \"opcache.interned_strings_buffer=16\" >> $ini_path/opcache.ini"
    sudo sh -c "echo \"opcache.max_accelerated_files = 20000\" >> $ini_path/opcache.ini"

    sudo sh -c "echo \";zend_extension=xdebug.so\" > $ini_path/xdebug.ini"
    sudo sh -c "echo \"xdebug.default_enable=1\" >> $ini_path/xdebug.ini"
    sudo sh -c "echo \"xdebug.profiler_enable=0\" >> $ini_path/xdebug.ini"
    sudo sh -c "echo \"xdebug.idekey=PHPSTORM\" >> $ini_path/xdebug.ini"
    sudo sh -c "echo \"xdebug.max_nesting_level=200\" >> $ini_path/xdebug.ini"
    sudo sh -c "echo \"xdebug.remote_enable=1\" >> $ini_path/xdebug.ini"
    sudo sh -c "echo \"xdebug.remote_autostart=0\" >> $ini_path/xdebug.ini"

    sudo phpenmod -v ${VERSION} apcu ast ssh2 xdebug
done

sudo cp php-switch.sh /usr/local/bin/php-switch
sudo chmod +x /usr/local/bin/php-switch

