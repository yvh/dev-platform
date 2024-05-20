#!/usr/bin/env bash

set -ex

curl --silent --show-error --location "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x04e38ce134b239b9f38f82ee8a993c2521c5f0ba" | sudo gpg --dearmor --output /etc/apt/keyrings/remmina.gpg
echo "Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/remmina.gpg
URIs: https://ppa.launchpadcontent.net/remmina-ppa-team/remmina-next/ubuntu
Suites: $(lsb_release --codename --short)
Components: main" | sudo tee /etc/apt/sources.list.d/remmina.sources
sudo apt update && sudo apt install --assume-yes remmina
