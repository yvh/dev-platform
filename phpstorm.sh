#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo bash "$0" "$@"
fi

echo "⚡ Installing PhpStorm IDE..."
[ -d /opt/phpstorm ] && rm --recursive --force /opt/phpstorm
mkdir --parents /opt/phpstorm
curl --silent --show-error --fail --location "$(curl --silent "https://data.services.jetbrains.com//products/releases?code=PS&latest=true&type=release" | jq --raw-output ".PS[0].downloads.linux.link")" | tar --extract --gzip --directory /opt/phpstorm --strip-components=1
