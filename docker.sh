#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    exit
fi

curl --silent --show-error --location "https://download.docker.com/linux/debian/gpg" | gpg --dearmor --output /etc/apt/keyrings/docker.gpg
echo "Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/docker.gpg
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable" | tee /etc/apt/sources.list.d/docker.sources
apt update && apt install --assume-yes docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo "Which user must be added to docker group?"
read docker_user
usermod --append --groups docker $docker_user
