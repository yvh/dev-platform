#!/usr/bin/env bash

set -euo pipefail

if [ "${EUID:-$(id -u)}" -eq 0 ] || [ -n "${SUDO_USER:-}" ]; then
  echo "error: must be run as a regular user (no root / no sudo)" >&2
  exit 1
fi

echo "⚡ Installing JetBrains Toolbox..."
install -d "$HOME/.local/share/JetBrains/Toolbox"
curl --silent --show-error --location "$(curl --silent --location "https://data.services.jetbrains.com//products/releases?code=TBA&latest=true&type=release" | jq --raw-output ".TBA[0].downloads.linux.link")" | tar --extract --gzip --directory "$HOME/.local/share/JetBrains/Toolbox" --strip-components=1
