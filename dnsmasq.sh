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

# Create dispatcher script to update dnsmasq and Docker config
cat > /etc/NetworkManager/dispatcher.d/10-update-dnsmasq-docker <<'EOF'
#!/usr/bin/env bash
# Auto update dnsmasq and Docker config based on current VM IP

IFACE=$1
STATUS=$2

# Only act on "up" events
if [ "$STATUS" != "up" ] && [ "$STATUS" != "vpn-up" ]; then
    exit 0
fi

# Only proceed if IFACE starts with 'ens'
if [[ ! "$IFACE" =~ ^ens ]]; then
    logger "Interface $IFACE ignored (not ens*)."
    exit 0
fi

# Get the main IP used to reach the default route
VM_IP=$(ip route get 1 | awk '{print $7; exit}')

if [ -z "$VM_IP" ]; then
    logger "No IP detected, skipping DNS config update."
    exit 0
fi

# Update dnsmasq listen.conf
cat > /etc/NetworkManager/dnsmasq.d/listen.conf <<EOL
# Listen on loopback and main VM IP
listen-address=127.0.0.1
listen-address=$VM_IP
EOL

# Update Docker daemon.json
DNS_LIST=$(nmcli --fields IP4.DNS dev show | grep IP4.DNS | awk '{print $2}' | xargs)
JSON_DNS=""
for ip in $DNS_LIST; do
    JSON_DNS="${JSON_DNS}${JSON_DNS:+, }\"$ip\""
done

# Also add the VM IP itself as DNS for Docker
JSON_DNS="\"$VM_IP\"${JSON_DNS:+, $JSON_DNS}"

cat > /etc/docker/daemon.json <<EOL
{
  "dns": [$JSON_DNS]
}
EOL

# Restart Docker
systemctl restart docker

logger "Updated dnsmasq listen-address and Docker DNS to use $VM_IP"
EOF

# Make dispatcher script executable
chmod +x /etc/NetworkManager/dispatcher.d/10-update-dnsmasq-docker

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
