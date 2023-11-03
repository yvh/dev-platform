#!/usr/bin/env bash

set -ex

curl --silent --show-error --location "https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.jammy_amd64.deb" --output /tmp/wkhtmltox_amd64.deb
sudo apt install --assume-yes /tmp/wkhtmltox_amd64.deb
rm --recursive --force /tmp/wkhtmltox_amd64.deb
