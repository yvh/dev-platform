#!/usr/bin/env bash

set -ex

NVM_VERSION=$(curl --silent --location https://api.github.com/repos/nvm-sh/nvm/releases/latest | jq --raw-output '.name')
curl --silent --show-error --location "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | bash
