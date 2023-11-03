#!/usr/bin/env bash

set -ex

curl --silent --show-error --location "https://dbeaver.io/debs/dbeaver.gpg.key"  | sudo gpg --dearmor --output /etc/apt/keyrings/dbeaver.gpg
echo "Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/dbeaver.gpg
URIs: https://dbeaver.io/debs/dbeaver-ce
Suites: /" | sudo tee /etc/apt/sources.list.d/dbeaver-ce.sources
sudo apt update && sudo apt install --assume-yes dbeaver-ce
