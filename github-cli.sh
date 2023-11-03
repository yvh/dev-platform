#!/usr/bin/env bash

set -ex

curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2c6106201985b60e6c7ac87323f3d4ea75716059" | sudo gpg --dearmor -o /etc/apt/keyrings/github.gpg
echo "Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/github.gpg
URIs: https://cli.github.com/packages
Suites: stable
Components: main" | sudo tee /etc/apt/sources.list.d/github.sources
sudo apt update && sudo apt install -y gh
