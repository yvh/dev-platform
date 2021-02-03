#!/usr/bin/env bash

set -ex

for VERSION in 7.3 7.4 8.0; do
  sudo apt install -y php${VERSION}-{bz2,cli,curl,gd,intl,ldap,mbstring,mysql,opcache,readline,xml,xsl,zip}

  if [[ ${VERSION} != 8\.* ]]; then
      sudo apt install -y php${VERSION}-json
  fi

  cd /etc/php/${VERSION}/cli
  sudo sed -i -e "s|max_execution_time = 30|max_execution_time = 60|" php.ini
  sudo sed -i -e "s|memory_limit = 128M|memory_limit = 512M|" php.ini
  sudo sed -i -e "s|post_max_size = 8M|post_max_size = 55M|" php.ini
  sudo sed -i -e "s|upload_max_filesize = 2M|upload_max_filesize = 50M|" php.ini
  sudo sed -i -e "s|;date.timezone =|date.timezone = Europe/Brussels|" php.ini
  sudo sed -i -e "s|;cgi.fix_pathinfo=1|cgi.fix_pathinfo = 0|" php.ini
  sudo sed -i -e "s|;realpath_cache_ttl = 120|realpath_cache_ttl = 600|" php.ini
  sudo sed -i -e "s|;realpath_cache_size = 4096k|realpath_cache_size = 4096K|" php.ini
done

sudo apt install -y php-pear libssh2-1-dev

for VERSION in 7.3 7.4 8.0; do
  sudo update-alternatives --set php /usr/bin/php${VERSION}
  sudo update-alternatives --set php-config /usr/bin/php-config${VERSION}
  sudo update-alternatives --set phpize /usr/bin/phpize${VERSION}

  sudo pecl -d php_suffix=${VERSION} install apcu xdebug && sudo pecl uninstall -r apcu xdebug

  cd /etc/php/${VERSION}/mods-available
  sudo sh -c 'echo "extension=apcu.so" > apcu.ini'
  sudo sh -c 'echo "apc.enabled=1" >> apcu.ini'
  sudo sh -c 'echo "apc.shm_segments=1" >> apcu.ini'
  sudo sh -c 'echo "apc.shm_size=128M" >> apcu.ini'
  sudo sh -c 'echo "apc.ttl=7200" >> apcu.ini'
  sudo sh -c 'echo "apc.enable_cli=0" >> apcu.ini'
  sudo phpenmod -v ${VERSION} -s cli apcu

  sudo sh -c 'echo "opcache.enable=1" >> opcache.ini'
  sudo sh -c 'echo "opcache.enable_cli=1" >> opcache.ini'
  sudo sh -c 'echo "opcache.revalidate_freq=2" >> opcache.ini'
  sudo sh -c 'echo "opcache.validate_timestamps=1" >> opcache.ini'
  sudo sh -c 'echo "opcache.interned_strings_buffer=16" >> opcache.ini'
  sudo sh -c 'echo "opcache.max_accelerated_files = 20000" >> opcache.ini'

  sudo sh -c 'echo ";zend_extension=xdebug.so" > xdebug.ini'
  sudo sh -c 'echo "xdebug.default_enable=1" >> xdebug.ini'
  sudo sh -c 'echo "xdebug.profiler_enable=0" >> xdebug.ini'
  sudo sh -c 'echo "xdebug.idekey=PHPSTORM" >> xdebug.ini'
  sudo sh -c 'echo "xdebug.max_nesting_level=200" >> xdebug.ini'
  sudo sh -c 'echo "xdebug.remote_enable=1" >> xdebug.ini'
  sudo sh -c 'echo "xdebug.remote_autostart=0" >> xdebug.ini'
  sudo phpenmod -v ${VERSION} -s cli xdebug
  
  if [[ ${VERSION} != 8\.* ]]; then
    sudo pecl -d php_suffix=${VERSION} install ssh2-1.2 && sudo pecl uninstall -r ssh2
    sudo sh -c 'echo "extension=ssh2.so" > ssh2.ini'
    sudo phpenmod -v ${VERSION} -s cli ssh2
  fi
done
