#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo bash "$0" "$@"
fi

apt update
apt install libnss3-tools

curl --silent --show-error --fail --location --insecure "https://artifactory.msnet.railb.be:443/artifactory/infrabel-pki/bundle.tar.gz" | tar --extract --gzip --directory /usr/local/share/ca-certificates --no-same-owner
for cert in /usr/local/share/ca-certificates/*.pem
do
    rootCertificate=${cert/.pem/.crt}
    mv "$cert" "$rootCertificate"
    # only chrome db. If firefox search on web to append certificates to firefox db
    certutil -d sql:${USER_OVERRIDE:-$(getent passwd 1000 | cut -d: -f6)}/.pki/nssdb -A -t "C,," -n ${rootCertificate##*/} -i $rootCertificate
done

update-ca-certificates
