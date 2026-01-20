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
user_home="$(getent passwd ${user} | cut -d: -f6)"
install --directory --owner ${user} --group ${user} "${user_home}/.local"
install --directory --owner ${user} --group ${user} "${user_home}/.local/share"
install --directory --owner ${user} --group ${user} "${user_home}/.local/share/JetBrains"
install --directory --owner ${user} --group ${user} "${user_home}/.local/share/JetBrains/Toolbox"
curl --silent --show-error --location "$(curl --silent --location "https://data.services.jetbrains.com//products/releases?code=TBA&latest=true&type=release" | jq --raw-output ".TBA[0].downloads.linux.link")" | runuser --user ${user} -- tar --extract --gzip --directory "${user_home}/.local/share/JetBrains/Toolbox" --strip-components=1
