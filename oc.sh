#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo bash "$0" "$@"
fi

echo "☁️ Installing OpenShift CLI (oc)..."
curl --silent --show-error --fail --location "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz" | tar --extract --gzip --directory /usr/local/bin oc kubectl
