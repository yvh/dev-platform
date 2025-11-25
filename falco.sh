#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo -E bash "$0" "$@"
fi

echo "💰 Installing Falco..."
curl --silent --show-error --fail --location "$(curl --silent --location https://api.github.com/repos/horussoftware/falco-fiscalteam3_4/releases/latest | jq --raw-output '.assets[] | select(.name | match("amd64.deb$")) | .browser_download_url')" --output /tmp/falco.deb
apt install --no-install-recommends --no-install-suggests --assume-yes /tmp/falco.deb
rm --recursive --force /tmp/falco.deb
