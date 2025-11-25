#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo -E bash "$0" "$@"
fi

if command -v "certutil" >/dev/null 2>&1; then
    echo "✅ certutil is already installed, skipping certutil (libnss3-tools) installation."
else
    echo "🔐 Installing certutil (libnss3-tools)..."
    apt update && apt install --no-install-recommends --no-install-suggests --assume-yes libnss3-tools
fi

echo "🔐 Downloading and installing Infrabel root certificates..."
curl --silent --show-error --fail --location --insecure "https://artifactory.msnet.railb.be/artifactory/infrabel-pki/bundle.tar.gz" | tar --extract --gzip --directory /usr/local/share/ca-certificates --no-same-owner
for cert in /usr/local/share/ca-certificates/*.pem
do
    rootCertificate=${cert/.pem/.crt}
    mv "$cert" "$rootCertificate"
    # only chrome db. If firefox search on web to append certificates to firefox db
    certutil -d sql:${USER_OVERRIDE:-$(getent passwd 1000 | cut -d: -f6)}/.pki/nssdb -A -t "C,," -n ${rootCertificate##*/} -i $rootCertificate
done

echo "🔐 Updating system CA certificates..."
update-ca-certificates --fresh
