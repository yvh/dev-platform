#!/usr/bin/env bash

set -ex

for VERSION in 5.6 7.0 7.1 7.2 7.3 7.4 8.0; do
  sudo apt install -y php${VERSION} php${VERSION}-{bz2,cli,curl,gd,intl,ldap,mbstring,mysql,opcache,readline,xml,xsl,zip}

  if [[ ${VERSION} != 8\.* ]]; then
      sudo apt install -y php${VERSION}-json
  fi


  for SYSTEM in apache2 cli; do
    cd /etc/php/${VERSION}/${SYSTEM}
    sudo sed -i -e "s|max_execution_time = 30|max_execution_time = 60|" php.ini
    sudo sed -i -e "s|memory_limit = 128M|memory_limit = 512M|" php.ini
    sudo sed -i -e "s|post_max_size = 8M|post_max_size = 55M|" php.ini
    sudo sed -i -e "s|upload_max_filesize = 2M|upload_max_filesize = 50M|" php.ini
    sudo sed -i -e "s|;date.timezone =|date.timezone = Europe/Brussels|" php.ini
    sudo sed -i -e "s|;cgi.fix_pathinfo=1|cgi.fix_pathinfo = 0|" php.ini
    sudo sed -i -e "s|;realpath_cache_ttl = 120|realpath_cache_ttl = 600|" php.ini

    if [[ ${VERSION} == 5\.* ]]; then
      sudo sed -i -e "s|;realpath_cache_size = 16k|realpath_cache_size = 4096K|" php.ini
    else
      sudo sed -i -e "s|;realpath_cache_size = 4096k|realpath_cache_size = 4096K|" php.ini
    fi
  done
done

sudo apt install -y php-{apcu,xdebug,ssh2}

for VERSION in 5.6 7.0 7.1 7.2 7.3 7.4 8.0; do
  cd /etc/php/${VERSION}/mods-available
  sudo sh -c 'echo "apc.enabled=1" >> apcu.ini'
  sudo sh -c 'echo "apc.shm_segments=1" >> apcu.ini'
  sudo sh -c 'echo "apc.shm_size=128M" >> apcu.ini'
  sudo sh -c 'echo "apc.ttl=7200" >> apcu.ini'
  sudo sh -c 'echo "apc.enable_cli=0" >> apcu.ini'

  sudo sh -c 'echo "opcache.enable=1" >> opcache.ini'
  sudo sh -c 'echo "opcache.enable_cli=1" >> opcache.ini'
  sudo sh -c 'echo "opcache.revalidate_freq=2" >> opcache.ini'
  sudo sh -c 'echo "opcache.validate_timestamps=1" >> opcache.ini'
  sudo sh -c 'echo "opcache.interned_strings_buffer=16" >> opcache.ini'
  sudo sh -c 'echo "opcache.max_accelerated_files = 20000" >> opcache.ini'

  sudo sed -i -e "s|zend_extension|;zend_extension|" xdebug.ini
  sudo sh -c 'echo "xdebug.default_enable=1" >> xdebug.ini'
  sudo sh -c 'echo "xdebug.profiler_enable=0" >> xdebug.ini'
  sudo sh -c 'echo "xdebug.idekey=PHPSTORM" >> xdebug.ini'
  sudo sh -c 'echo "xdebug.max_nesting_level=200" >> xdebug.ini'
  sudo sh -c 'echo "xdebug.remote_enable=1" >> xdebug.ini'
  sudo sh -c 'echo "xdebug.remote_autostart=0" >> xdebug.ini'
done
