#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    exit
fi

curl --silent --show-error --location "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" --output /tmp/google-chrome-stable_current_amd64.deb
apt install --assume-yes /tmp/google-chrome-stable_current_amd64.deb
rm --recursive --force /tmp/google-chrome-stable_current_amd64.deb
