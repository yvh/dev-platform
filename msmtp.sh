#!/usr/bin/env bash

set -ex

sudo apt install --assume-yes msmtp-mta
sudo cp config/msmtprc /etc/msmtprc
sudo chmod g-w /etc/msmtprc
