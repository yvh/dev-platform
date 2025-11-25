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
echo "🔧 Enabling contrib and non-free repository..."
cat > /etc/apt/sources.list.d/debian-contrib-nonfree.sources << EOF
Types: deb
Architectures: amd64
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
URIs: http://deb.debian.org/debian
Suites: $(lsb_release --codename --short) $(lsb_release --codename --short)-updates
Components: contrib non-free

Types: deb
Architectures: amd64
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
URIs: http://security.debian.org/debian-security
Suites: $(lsb_release --codename --short)-security
Components: contrib non-free
EOF

echo ""
echo "🔧 Enabling backports repository..."
cat > /etc/apt/sources.list.d/debian-backports.sources << EOF
Types: deb
Architectures: amd64
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
URIs: http://deb.debian.org/debian
Suites: $(lsb_release --codename --short)-backports
Components: main contrib non-free non-free-firmware
EOF

echo "📦 Setting high priority for backports..."
cat > /etc/apt/preferences.d/99-debian-backports << EOF
Package: *
Pin: release n=$(lsb_release --codename --short)-backports
Pin-Priority: 900
EOF

echo ""
echo "🧹 Cleaning up unnecessary deb-src entries..."
sed --in-place --expression "s|^deb-src|#deb-src|" /etc/apt/sources.list

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
    
