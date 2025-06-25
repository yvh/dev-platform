#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo bash "$0" "$@"
fi

echo "💰 Installing Falco..."
curl --silent --show-error --location "$(curl --silent --location https://api.github.com/repos/horussoftware/falco-fiscalteam3_4/releases/latest | jq --raw-output '.assets[] | select(.name | match("amd64.deb$")) | .browser_download_url')" --output /tmp/falco.deb
apt install --assume-yes /tmp/falco.deb
rm --recursive --force /tmp/falco.deb
