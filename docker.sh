#!/usr/bin/env bash

set -ex

curl --silent --show-error --location "https://download.docker.com/linux/ubuntu/gpg" | sudo gpg --dearmor --output /etc/apt/keyrings/docker.gpg
echo "Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/docker.gpg
URIs: https://download.docker.com/linux/ubuntu
Suites: $(lsb_release --codename --short)
Components: stable" | sudo tee /etc/apt/sources.list.d/docker.sources
sudo apt update && sudo apt install --assume-yes docker-ce docker-ce-cli containerd.io
sudo usermod --append --groups docker yvh

DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir --parents $DOCKER_CONFIG/cli-plugins
curl --silent --show-error --location "https://github.com/docker/compose/releases/download/v2.23.1/docker-compose-linux-x86_64" --output $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
