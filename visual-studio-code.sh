#!/usr/bin/env bash

set -ex

curl -SL "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -o /tmp/code_amd64.deb
sudo apt install -y /tmp/code_amd64.deb
rm -rf /tmp/code_amd64.deb

