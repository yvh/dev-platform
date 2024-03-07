#!/usr/bin/env bash

set -ex

curl --silent --show-error --location "https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg" | sudo gpg --dearmor --output /etc/apt/trusted.gpg.d/spotify-2023-11-16-6224F9941A8AA6D1.gpg
echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt update && sudo apt install --assume-yes spotify-client
