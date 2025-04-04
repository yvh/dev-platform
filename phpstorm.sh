#!/usr/bin/env bash

set -ex

sudo mkdir --parents /opt/phpstorm
curl --silent --show-error --location "$(curl --silent "https://data.services.jetbrains.com//products/releases?code=PS&latest=true&type=release" | jq --raw-output ".PS[0].downloads.linux.link")" | sudo tar --extract --gzip --directory /opt/phpstorm --strip-components=1
