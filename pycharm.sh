#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo bash "$0" "$@"
fi

echo "🐍 Installing PyCharm IDE..."
[ -d /opt/pycharm ] && rm --recursive --force /opt/pycharm
mkdir --parents /opt/pycharm
curl --silent --show-error --location "$(curl --silent "https://data.services.jetbrains.com//products/releases?code=PCP&latest=true&type=release" | jq --raw-output ".PCP[0].downloads.linux.link")" | tar --extract --gzip --directory /opt/pycharm --strip-components=1
