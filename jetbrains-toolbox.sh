#!/usr/bin/env bash

set -ex

sudo apt update
sudo apt install --assume-yes libfuse2

if [[ ! -f ~/.local/share/JetBrains/Toolbox/bin/jetbrains-toolbox ]]; then
    URL=$(curl --silent "https://data.services.jetbrains.com//products/releases?code=TBA&latest=true&type=release" | jq --raw-output ".TBA[0].downloads.linux.link")
    DOWNLOAD_TEMP_DIR=$(mktemp --directory)
    mkdir --parents ${DOWNLOAD_TEMP_DIR}

    curl --silent --show-error --location "${URL}" | tar --extract --gzip --directory ${DOWNLOAD_TEMP_DIR} --strip-components=1

    ${DOWNLOAD_TEMP_DIR}/jetbrains-toolbox

    rm --recursive --force ${DOWNLOAD_TEMP_DIR}
fi
