#!/usr/bin/env bash

sed --in-place --expression "s|^deb-src|#deb-src|" /etc/apt/sources.list                                                                              

echo "Types: deb
Architectures: amd64
URIs: http://deb.debian.org/debian
Suites: bookworm-backports
Components: main contrib non-free non-free-firmware" | tee /etc/apt/sources.list.d/debian-backports.sources

echo "Package: *
Pin: release n=bookworm-backports
Pin-Priority: 900" | tee /etc/apt/preferences.d/99-backports

apt update && apt install --assume-yes gnome-core open-vm-tools-desktop sudo curl git
echo "Which user must be added to sudoers group?"
read sudoers_user
usermod --append --groups sudo $sudoers_user
rm /etc/network/interfaces

echo "\nYou can reboot now!"
