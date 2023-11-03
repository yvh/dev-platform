#!/usr/bin/env bash

set -ex
sudo apt install -y msmtp-mta
sudo cp config/msmtprc /etc/msmtprc
sudo chmod g-w /etc/msmtprc
