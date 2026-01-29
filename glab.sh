#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo --preserve-env bash "$0" "$@"
fi

echo "🐙 Installing GitLab CLI (glab)..."
curl --silent --show-error --fail --location "$(curl --silent --location https://gitlab.com/api/v4/projects/gitlab-org%2Fcli/releases | jq --raw-output '.[0].assets.links[] | select(.name | match("amd64.deb$")) | .direct_asset_url')" --output /tmp/glab.deb
apt install --no-install-recommends --no-install-suggests --assume-yes /tmp/glab.deb
rm --recursive --force /tmp/glab.deb
