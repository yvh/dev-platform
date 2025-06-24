#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    exit
fi

curl --silent --show-error --location "$(curl --silent --location https://api.github.com/repos/horussoftware/falco-fiscalteam3_4/releases/latest | jq --raw-output '.assets[] | select(.name | match("amd64.deb$")) | .browser_download_url')" --output /tmp/falco.deb
apt install --assume-yes /tmp/falco.deb
rm --recursive --force /tmp/falco.deb
