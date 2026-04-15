#!/usr/bin/env bash
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo --preserve-env bash "$0" "$@"
fi

if command -v "certutil" >/dev/null 2>&1; then
    echo "✅ certutil is already installed, skipping certutil (nss) installation."
else
    echo "🔐 Installing certutil (nss)..."
    pacman --sync --refresh --noconfirm --needed nss
fi

echo "🔐 Downloading and installing Infrabel root certificates..."
curl --silent --show-error --fail --location --insecure "https://artifactory.msnet.railb.be/artifactory/infrabel-pki/bundle.tar.gz" | tar --extract --gzip --directory /etc/ca-certificates/trust-source/anchors --no-same-owner
for cert in /etc/ca-certificates/trust-source/anchors/*.pem
do
    # only chrome db. If firefox search on web to append certificates to firefox db
    certutil -d sql:${USER_OVERRIDE:-$(getent passwd 1000 | cut -d: -f6)}/.pki/nssdb -A -t "C,," -n ${cert##*/} -i $cert
done

echo "🔐 Updating system CA certificates..."
update-ca-trust extract

echo "✅ Done."
