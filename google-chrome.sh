#!/usr/bin/env bash

set -ex

curl -SL "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" -o /tmp/google-chrome-stable_current_amd64.deb
sudo apt install -y /tmp/google-chrome-stable_current_amd64.deb
rm -rf /tmp/google-chrome-stable_current_amd64.deb
