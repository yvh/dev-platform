#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo bash "$0" "$@"
fi

echo "🌐 Setting dnsmasq..."

# Ensure NetworkManager configuration directory exists
mkdir --parents /etc/NetworkManager/conf.d
mkdir --parents /etc/NetworkManager/dnsmasq.d

# Configure NetworkManager to use embedded dnsmasq
cat >/etc/NetworkManager/conf.d/dns.conf <<EOF
[main]
dns=dnsmasq
EOF

# Create dnsmasq config for .local domains
cat >/etc/NetworkManager/dnsmasq.d/local.conf <<EOF
# Resolve *.local to 127.0.0.1
address=/.local/127.0.0.1
EOF

# Update hosts line to prioritize DNS over mDNS
sed --in-place 's/^hosts:.*/hosts:          files dns mdns4_minimal myhostname/' /etc/nsswitch.conf

# Restart NetworkManager to apply changes
systemctl restart NetworkManager

# Optional: show status
echo ""
echo "Done!"
echo "You can test resolution with:"
echo "  getent hosts test.local"
echo "  ping test.local"
