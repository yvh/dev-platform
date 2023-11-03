#!/usr/bin/env bash

set -ex

curl -fsSL "https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.jammy_amd64.deb" -o /tmp/wkhtmltox_amd64.deb
sudo apt install -y /tmp/wkhtmltox_amd64.deb
rm -rf /tmp/wkhtmltox_amd64.deb
