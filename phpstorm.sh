#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    exit
fi

[ -d /opt/phpstorm ] && rm --recursive --force /opt/phpstorm
mkdir --parents /opt/phpstorm
curl --silent --show-error --location "$(curl --silent "https://data.services.jetbrains.com//products/releases?code=PS&latest=true&type=release" | jq --raw-output ".PS[0].downloads.linux.link")" | tar --extract --gzip --directory /opt/phpstorm --strip-components=1
