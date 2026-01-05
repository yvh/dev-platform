#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo -E bash "$0" "$@"
fi

echo "⚡ Installing JetBrains Toolbox..."
user=${USER_OVERRIDE:-$(getent passwd 1000 | cut -d: -f1)}
jetbrains_toolbox_directory="$(getent passwd ${user} | cut -d: -f6)/.local/share/JetBrains/Toolbox"
install --directory --owner ${user} --group ${user} "${jetbrains_toolbox_directory}"
curl --silent --show-error --location "$(curl --silent --location "https://data.services.jetbrains.com//products/releases?code=TBA&latest=true&type=release" | jq --raw-output ".TBA[0].downloads.linux.link")" | runuser --user ${user} -- tar --extract --gzip --directory ${jetbrains_toolbox_directory} --strip-components=1
