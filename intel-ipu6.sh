#!/usr/bin/env bash

set -ex

sudo apt-key --keyring /etc/apt/trusted.gpg.d/intel-ipu6.gpg adv --keyserver keyserver.ubuntu.com --recv-key 7B85BB3BB81D9DAFF9F06250B52B913A41086767
sudo sh -c 'echo "deb https://ppa.launchpadcontent.net/oem-solutions-group/intel-ipu6/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/intel-ipu6.list'
sudo sh -c 'echo "#deb-src https://ppa.launchpadcontent.net/oem-solutions-group/intel-ipu6/ubuntu $(lsb_release -cs) main" >> /etc/apt/sources.list.d/intel-ipu6.list'
sudo apt update && sudo apt install libcamhal-ipu6ep0