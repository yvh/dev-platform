#!/usr/bin/env bash

set -ex

curl --silent --show-error --location "https://github.com/torakiki/pdfsam/releases/download/v5.1.3/pdfsam_5.1.3-1_amd64.deb" --output /tmp/pdfsam.deb
sudo apt install --assume-yes /tmp/pdfsam.deb
rm --recursive --force /tmp/pdfsam.deb
