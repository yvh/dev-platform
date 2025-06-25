#!/usr/bin/env bash

echo "📬 Installing Postman..."

[ -d /opt/postman ] && rm --recursive --force /opt/postman
mkdir --parents /opt/postman
curl --silent --show-error --fail --location "https://dl.pstmn.io/download/latest/linux_64" | sudo tar --extract --gzip --directory /opt/postman --strip-components=2
echo "[Desktop Entry]
Encoding=UTF-8
Name=Postman
Exec=/opt/postman/Postman %U
Icon=/opt/postman/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;" | sudo tee /usr/share/applications/Postman.desktop
