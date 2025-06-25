#!/usr/bin/env bash

echo "🐙 Installing Git..."

curl --silent --show-error --fail --location "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xF911AB184317630C59970973E363C90F8F1B6217" | sudo gpg --dearmor --output /etc/apt/keyrings/git.gpg
echo "Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/git.gpg
URIs: https://ppa.launchpadcontent.net/git-core/ppa/ubuntu
Suites: $(lsb_release --codename --short)
Components: main" | sudo tee /etc/apt/sources.list.d/git.sources
sudo apt update && sudo apt install --assume-yes git
