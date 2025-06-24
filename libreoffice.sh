#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    exit
fi

apt update && apt install --assume-yes \
    libreoffice-calc \
    libreoffice-draw \
    libreoffice-gnome \
    libreoffice-impress \
    libreoffice-math \
    libreoffice-nlpsolver \
    libreoffice-numbertext \
    libreoffice-script-provider-python \
    libreoffice-writer \
    libreoffice-writer2latex \
    libreoffice-writer2xhtml
