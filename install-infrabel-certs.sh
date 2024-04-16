#!/usr/bin/env bash

set -ex

sudo apt update
sudo apt install libnss3-tools

curl --silent --show-error --location --insecure "https://artifactory.msnet.railb.be:443/artifactory/infrabel-pki/bundle.tar.gz" | sudo tar --extract --gzip --directory /usr/local/share/ca-certificates --no-same-owner
for cert in /usr/local/share/ca-certificates/*.pem
do
    rootCertificate=${cert/.pem/.crt}
    sudo mv "$cert" "$rootCertificate"
    sudo certutil -d sql:$HOME/.pki/nssdb -A -t "C,," -n ${rootCertificate##*/} -i $rootCertificate
done

sudo update-ca-certificates
