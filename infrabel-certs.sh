#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo --preserve-env bash "$0" "$@"
fi

echo "🔐 Downloading and installing Infrabel root certificates..."
curl --silent --show-error --fail --location --insecure "https://artifactory.msnet.railb.be/artifactory/infrabel-pki/bundle.tar.gz" | tar --extract --gzip --directory /usr/local/share/ca-certificates --no-same-owner
for cert in /usr/local/share/ca-certificates/*.pem
do
    rootCertificate=${cert/.pem/.crt}
    mv "$cert" "$rootCertificate"
done

echo "🔐 Updating system CA certificates..."
update-ca-certificates --fresh
