#!/usr/bin/env bash

echo "🧠 Installing Visual Studio Code..."

curl --silent --show-error --fail --location "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" --output /tmp/code_amd64.deb
sudo apt install --assume-yes /tmp/code_amd64.deb
rm --recursive --force /tmp/code_amd64.deb
