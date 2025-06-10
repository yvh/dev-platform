#!/usr/bin/env bash

set -ex

[ -d /opt/pycharm ] && sudo rm --recursive --force /opt/pycharm
sudo mkdir --parents /opt/pycharm
curl --silent --show-error --location "$(curl --silent "https://data.services.jetbrains.com//products/releases?code=PCP&latest=true&type=release" | jq --raw-output ".PCP[0].downloads.linux.link")" | sudo tar --extract --gzip --directory /opt/pycharm --strip-components=1
