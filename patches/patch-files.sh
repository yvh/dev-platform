#!/usr/bin/env bash

sudo patch /etc/php/5.6/apache2/php.ini 5.6-apache2.patch
sudo patch /etc/php/5.6/cli/php.ini 5.6-cli.patch

sudo patch /etc/php/7.0/apache2/php.ini 7.0-apache2.patch
sudo patch /etc/php/7.0/cli/php.ini 7.0-cli.patch

sudo patch /etc/php/7.1/apache2/php.ini 7.1-apache2.patch
sudo patch /etc/php/7.1/cli/php.ini 7.1-cli.patch

sudo patch /etc/php/7.2/apache2/php.ini 7.2-apache2.patch
sudo patch /etc/php/7.2/cli/php.ini 7.2-cli.patch
