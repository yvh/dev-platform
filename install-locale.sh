#!/usr/bin/env bash

set -ex

wget --output-document=/tmp/en_BE "https://gist.github.com/yvh/630368018d7c683aca8da9e2baf7bfb9/raw/48d0bf07c296fabb8d927317e2a1ac0a271c313b/en_BE"
sudo cp /tmp/en_BE /usr/share/i18n/locales/en_BE
sudo localedef --inputfile en_BE --force --charmap UTF-8 en_BE

sudo sed --in-place --expression "s|^de_BE\.UTF-8|# de_BE.UTF-8|" /etc/locale.gen
sudo sed --in-place --expression "s|^# en_GB\.UTF-8|en_GB.UTF-8|" /etc/locale.gen
sudo sed --in-place --expression "s|^# fr_BE\.UTF-8|fr_BE.UTF-8|" /etc/locale.gen
sudo sed --in-place --expression "/# en_BW\.UTF-8.*/a en_BE.UTF-8 UTF-8" /etc/locale.gen

sudo rm --force /var/lib/locales/supported.d/*
sudo locale-gen

sudo sed --in-place --expression "s|en_GB|en_BE|g" /etc/default/locale
sudo sed --in-place --expression "/LC_MEASUREMENT=.*/a LC_MESSAGES=C.UTF-8" /etc/default/locale
