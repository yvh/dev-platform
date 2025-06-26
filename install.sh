#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo bash "$0" "$@"
fi

echo ""
echo "🧙 ‘Ah... you are root. A power not to be taken lightly.’"
echo "📜 Summoning the script from the archives of GitHub..."
echo ""

# locale
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/refs/heads/debian-vm/locale.sh" | bash

# /tmp to tmpfs
echo ""
echo "🧼 Mounting /tmp in memory (tmpfs)..."
cp /usr/share/systemd/tmp.mount /etc/systemd/system/
systemctl enable --now tmp.mount

# remove deb-src
echo ""
echo "🧹 Cleaning up unnecessary deb-src entries..."
sed --in-place --expression "s|^deb-src|#deb-src|" /etc/apt/sources.list                                                                              

# enable backports
echo ""
echo "🔧 Enabling backports repository..."
echo "Types: deb
Architectures: amd64
URIs: http://deb.debian.org/debian
Suites: bookworm-backports
Components: main contrib non-free non-free-firmware" | tee /etc/apt/sources.list.d/debian-backports.sources

echo "📦 Setting high priority for backports..."
echo "Package: *
Pin: release n=bookworm-backports
Pin-Priority: 900" | tee /etc/apt/preferences.d/99-backports

# upgrade & install some apps
echo ""
echo "🆙 Updating and upgrading the system..."
apt update && apt full-upgrade --assume-yes

echo ""
echo "📥 Installing essential tools and desktop apps..."
apt install --assume-yes build-essential apt-transport-https ca-certificates gnupg-agent software-properties-common \
    gnome-core open-vm-tools-desktop sudo curl git \
    vim sshfs htop zsh filezilla cntlm jq terminator netcat-openbsd rsync \
    fonts-dejavu fonts-lato fonts-open-sans fonts-roboto fonts-powerline \
    aspell-fr hyphen-fr mythes-fr hunspell-fr
apt install --assume-yes --no-install-recommends kdiff3 wireshark kompare

# remove uneccessary apps
echo ""
echo "🧽 Removing unnecessary default applications..."
apt-get purge --assume-yes fonts-lohit* fonts-tlwg* fonts-samyak* fonts-tibetan-machine fonts-lklug-sinhala nano \
    firefox-esr skanlite kio-audiocd thunderbird totem gnome-contacts gnome-online-accounts netcat-traditional \
    gnome-terminal
apt autoremove --purge --assume-yes

# customization
echo ""
echo "👤 Adding a user to the sudo group..."
echo "Which user must be added to sudoers group?"
read sudoers_user
usermod --append --groups sudo $sudoers_user

echo ""
echo "🧾 Adjusting network and terminal settings..."
rm /etc/network/interfaces
sed --in-place 's/#force_color_prompt=yes/force_color_prompt=yes/' /root/.bashrc
sed --in-place 's/01;32m/01;31m/' /root/.bashrc
sed --in-place 's/    SendEnv/#   SendEnv/g' /etc/ssh/ssh_config
sed --in-place '/dev\/sr0/d' /etc/fstab
echo ".host:/ /mnt/hgfs fuse.vmhgfs-fuse defaults,allow_other 0 0" >> /etc/fstab

# docker
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/refs/heads/debian-vm/docker.sh" | bash

# falco
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/refs/heads/debian-vm/falco.sh" | bash

# glab
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/refs/heads/debian-vm/glab.sh" | bash

# google chrome
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/refs/heads/debian-vm/google-chrome.sh" | bash

# libreoffice
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/refs/heads/debian-vm/libreoffice.sh" | bash

# mariadb
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/refs/heads/debian-vm/mariadb.sh" | bash

# oc
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/refs/heads/debian-vm/oc.sh" | bash

# pdfsam
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/refs/heads/debian-vm/pdfsam.sh" | bash

# phpstorm
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/refs/heads/debian-vm/phpstorm.sh" | bash

# postman
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/refs/heads/debian-vm/postman.sh" | bash

# pycharm
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/refs/heads/debian-vm/pycharm.sh" | bash

# visual studio code
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/refs/heads/debian-vm/visual-studio-code.sh" | bash

# change inotify for idea (phpstorm)
echo ""
echo "🔧 Tuning inotify settings for IDEs..."
echo "fs.inotify.max_user_watches = 1048576" > /etc/sysctl.d/99-idea.conf
sysctl --load --system

# full-upgrade
echo ""
echo "🔁 Final system upgrade and cleanup..."
apt full-upgrade --assume-yes
apt autoremove --purge --assume-yes

echo ""
echo "✅ ‘The script has run its course... may your server never segfault again.’"

