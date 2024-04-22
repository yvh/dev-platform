#!/usr/bin/env bash

set -ex

sudo apt update
sudo apt install --assume-yes dnsmasq
sudo sed --in-place 's/#listen-address=/listen-address=127.0.0.2/' /etc/dnsmasq.conf
sudo sed --in-place 's/#bind-interfaces/bind-interfaces/' /etc/dnsmasq.conf
sudo sed --in-place 's/#no-resolv/no-resolv/' /etc/dnsmasq.conf
sudo sed --in-place 's/#domain-needed/domain-needed/' /etc/dnsmasq.conf
sudo sed --in-place 's/#bogus-priv/bogus-priv/' /etc/dnsmasq.conf
echo "address=/local/127.0.0.1" | sudo tee /etc/dnsmasq.d/local
sudo sed --in-place 's/#IGNORE_RESOLVCONF/IGNORE_RESOLVCONF/' /etc/default/dnsmasq
sudo systemctl restart dnsmasq.service

sudo sed --in-place 's/#DNS=/DNS=127.0.0.2/' /etc/systemd/resolved.conf
sudo sed --in-place 's/#Domains=/Domains=~local/' /etc/systemd/resolved.conf
sudo systemctl restart systemd-resolved
