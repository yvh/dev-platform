#!/usr/bin/env bash

set -ex

sudo apt update && sudo apt install --assume-yes \
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
