#!/usr/bin/env bash

set -ex

curl --silent --show-error --location "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x97A37C0FB41AF4423282E5B493F4D583494746C8" | sudo gpg --dearmor --output /etc/apt/keyrings/graphics-drivers.gpg
echo "Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/graphics-drivers.gpg
URIs: https://ppa.launchpadcontent.net/oibaf/graphics-drivers/ubuntu
Suites: $(lsb_release --codename --short)
Components: main" | sudo tee /etc/apt/sources.list.d/graphics-drivers.sources
sudo apt update && sudo apt full-upgrade --assume-yes

