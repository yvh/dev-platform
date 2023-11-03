#!/usr/bin/env bash

set -ex

curl -SL "https://github.com/torakiki/pdfsam/releases/download/v5.1.3/pdfsam_5.1.3-1_amd64.deb" -o /tmp/pdfsam.deb
sudo apt install -y /tmp/pdfsam.deb
rm -rf /tmp/pdfsam.deb
