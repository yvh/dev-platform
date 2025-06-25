#!/usr/bin/env bash

echo "💰 Installing Falco..."

curl --silent --show-error --fail --location "$(curl --silent --location https://api.github.com/repos/horussoftware/falco-fiscalteam3_4/releases/latest | jq --raw-output '.assets[] | select(.name | match("amd64.deb$")) | .browser_download_url')" --output /tmp/falco.deb
sudo apt install --assume-yes /tmp/falco.deb
rm --recursive --force /tmp/falco.deb
