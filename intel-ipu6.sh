#!/usr/bin/env bash

set -ex

curl --silent --show-error --location "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x7b85bb3bb81d9daff9f06250b52b913a41086767" | sudo gpg --dearmor --output /etc/apt/keyrings/intel-ipu6.gpg
echo "Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/intel-ipu6.gpg
URIs: https://ppa.launchpadcontent.net/oem-solutions-group/intel-ipu6/ubuntu
Suites: $(lsb_release --codename --short)
Components: main" | sudo tee /etc/apt/sources.list.d/intel-ipu6.sources

sudo apt update && sudo apt install --assume-yes libcamhal-ipu6ep0
