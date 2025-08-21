#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo bash "$0" "$@"
fi

echo "⚡ Installing JetBrains Toolbox..."
user=${USER_OVERRIDE:-$(getent passwd 1000 | cut -d: -f1)}
toolbox_installation_path=$(getent passwd ${user} | cut -d: -f6)/.local/share/JetBrains/Toolbox
install --owner ${user} --group ${user} --directory ${toolbox_installation_path}
curl --silent --show-error --location "$(curl --silent --location "https://data.services.jetbrains.com//products/releases?code=TBA&latest=true&type=release" | jq --raw-output ".TBA[0].downloads.linux.link")" | tar --extract --gzip --directory ${toolbox_installation_path} --strip-components=1
chown -R ${user}: ${toolbox_installation_path}
