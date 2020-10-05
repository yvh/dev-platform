#!/usr/bin/env bash

set -ex

for VERSION in 5.6 7.0 7.1 7.2 7.3 7.4; do
  apt install php${VERSION} php${VERSION}-bz2 php${VERSION}-cli php${VERSION}-curl php${VERSION}-gd php${VERSION}-intl php${VERSION}-json php${VERSION}-ldap php${VERSION}-mbstring php${VERSION}-mysql php${VERSION}-opcache php${VERSION}-readline php${VERSION}-xml php${VERSION}-xsl php${VERSION}-zip

  for SYSTEM in apache2 cli; do
    cd /etc/php/${VERSION}/${SYSTEM}
    sed -i -e "s|max_execution_time = 30|max_execution_time = 60|" php.ini
    sed -i -e "s|memory_limit = 128M|memory_limit = 512M|" php.ini
    sed -i -e "s|post_max_size = 8M|post_max_size = 55M|" php.ini
    sed -i -e "s|upload_max_filesize = 2M|upload_max_filesize = 50M|" php.ini
    sed -i -e "s|;date.timezone =|date.timezone = Europe/Brussels|" php.ini
    sed -i -e "s|;cgi.fix_pathinfo=1|cgi.fix_pathinfo = 0|" php.ini
    sed -i -e "s|;realpath_cache_ttl = 120|realpath_cache_ttl = 600|" php.ini

    if [ ${VERSION} = "5.6" ]; then
      sed -i -e "s|;realpath_cache_size = 16k|realpath_cache_size = 4096K|" php.ini
    else
      sed -i -e "s|;realpath_cache_size = 4096k|realpath_cache_size = 4096K|" php.ini
    fi
  done
done

apt install php-apcu php-xdebug php-ssh2

for VERSION in 5.6 7.0 7.1 7.2 7.3 7.4; do
  cd /etc/php/${VERSION}/mods-available
  echo "apc.enabled=1" >> apcu.ini
  echo "apc.shm_segments=1" >> apcu.ini
  echo "apc.shm_size=128M" >> apcu.ini
  echo "apc.ttl=7200" >> apcu.ini
  echo "apc.enable_cli=0" >> apcu.ini

  echo "opcache.enable=1" >> opcache.ini
  echo "opcache.enable_cli=1" >> opcache.ini
  echo "opcache.revalidate_freq=2" >> opcache.ini
  echo "opcache.validate_timestamps=1" >> opcache.ini
  echo "opcache.interned_strings_buffer=16" >> opcache.ini
  echo "opcache.max_accelerated_files = 20000" >> opcache.ini

  sed -i -e "s|zend_extension|;zend_extension|" xdebug.ini
  echo "xdebug.default_enable=1" >> xdebug.ini
  echo "xdebug.profiler_enable=0" >> xdebug.ini
  echo "xdebug.idekey=PHPSTORM" >> xdebug.ini; \
  echo "xdebug.max_nesting_level=200" >> xdebug.ini
  echo "xdebug.remote_enable=1" >> xdebug.ini
  echo "xdebug.remote_autostart=0" >> xdebug.ini
done
