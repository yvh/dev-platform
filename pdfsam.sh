#!/usr/bin/env bash

set -ex

curl --silent --show-error --location "$(curl --silent --location https://api.github.com/repos/torakiki/pdfsam/releases/latest | jq --raw-output '.assets[] | select(.name | match("amd64.deb$")) | .browser_download_url')" --output /tmp/pdfsam.deb
sudo apt install --assume-yes /tmp/pdfsam.deb
rm --recursive --force /tmp/pdfsam.deb
