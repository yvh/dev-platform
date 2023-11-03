#!/usr/bin/env bash

set -ex

curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x36e81c9267fd1383fcc4490983fba1751378b444" | sudo gpg --dearmor -o /etc/apt/keyrings/libreoffice.gpg
echo "Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/libreoffice.gpg
URIs: https://ppa.launchpadcontent.net/libreoffice/ppa/ubuntu
Suites: $(lsb_release -cs)
Components: main" | sudo tee /etc/apt/sources.list.d/libreoffice.sources
sudo apt update && sudo apt install -y libreoffice libreoffice-style-breeze 
