#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo -E bash "$0" "$@"
fi

if [ ! -d "/etc/apt/apt.conf.d" ]; then
    mkdir -p /etc/apt/apt.conf.d
fi

echo ""
echo "🔧 Disable apt recommends and suggests..."
cat > /etc/apt/apt.conf.d/99norecommends << EOF
APT::Install-Recommends "false";
APT::Install-Suggests "false";
EOF

echo ""
echo "🔧 Enabling debian repository..."
cat > /etc/apt/sources.list.d/debian.sources << EOF
Types: deb
Architectures: amd64
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
URIs: https://deb.debian.org/debian
Suites: $(lsb_release --codename --short) $(lsb_release --codename --short)-updates $(lsb_release --codename --short)-backports
Components: main contrib non-free non-free-firmware

Types: deb
Architectures: amd64
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
URIs: https://security.debian.org/debian-security
Suites: $(lsb_release --codename --short)-security
Components: main contrib non-free non-free-firmware
EOF

echo "📦 Setting high priority for backports..."
cat > /etc/apt/preferences.d/99-debian-backports << EOF
Package: *
Pin: release n=$(lsb_release --codename --short)-backports
Pin-Priority: 900
EOF

echo ""
echo "🧹 Cleaning up unnecessary sources.list..."
rm --force /etc/apt/sources.list{,~}

echo ""
echo "🆙 Updating and upgrading the system..."
apt update && apt full-upgrade --assume-yes

echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/debian-vm/locale.sh" | bash

echo ""
echo "📥 Installing bootstraping tools..."
apt install --no-install-recommends --no-install-suggests --assume-yes \
    git \
    lsb-release \
    patch
    
