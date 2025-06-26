#!/usr/bin/env bash

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
    certutil -d sql:$HOME/.pki/nssdb -A -t "C,," -n ${rootCertificate##*/} -i $rootCertificate
done

update-ca-certificates
