#!/usr/bin/env bash

echo "🌐 Installing Google Chrome..."

curl --silent --show-error --fail --location "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" --output /tmp/google-chrome-stable_current_amd64.deb
sudo apt install --assume-yes /tmp/google-chrome-stable_current_amd64.deb
rm --recursive --force /tmp/google-chrome-stable_current_amd64.deb
