#!/usr/bin/env bash

set -ex

curl --silent --show-error --location "$(curl --silent --location https://gitlab.com/api/v4/projects/gitlab-org%2Fcli/releases | jq --raw-output '.[0].assets.links[] | select(.name | match("amd64.deb$")) | .direct_asset_url')" --output /tmp/glab.deb
sudo apt install --assume-yes /tmp/glab.deb
rm --recursive --force /tmp/glab.deb
