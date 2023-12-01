#!/usr/bin/env bash

set -ex

DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir --parents $DOCKER_CONFIG/cli-plugins
curl --silent --show-error --location "https://github.com/docker/compose/releases/download/v2.23.3/docker-compose-linux-x86_64" --output $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose

