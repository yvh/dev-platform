#!/usr/bin/env bash

set -ex

sudo mkdir --parents /opt/postman
curl --silent --show-error --location "https://dl.pstmn.io/download/latest/linux_64" | sudo tar --extract --gzip --directory /opt/postman --strip-components=2
echo "[Desktop Entry]
Encoding=UTF-8
Name=Postman
Exec=/opt/postman/Postman %U
Icon=/opt/postman/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;" | sudo tee /usr/share/applications/Postman.desktop
