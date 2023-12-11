#!/usr/bin/env bash

set -ex

curl --silent --show-error --location "https://download.docker.com/linux/ubuntu/gpg" | sudo gpg --dearmor --output /etc/apt/keyrings/docker.gpg
echo "Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/docker.gpg
URIs: https://download.docker.com/linux/ubuntu
Suites: $(lsb_release --codename --short)
Components: stable" | sudo tee /etc/apt/sources.list.d/docker.sources
sudo apt update && sudo apt install --assume-yes docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo usermod --append --groups docker yvh

