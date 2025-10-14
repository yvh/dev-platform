#!/usr/bin/env bash

set -e

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

export DEBIAN_FRONTEND=noninteractive

# locale
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/debian-vm/locale.sh" | bash

# remove deb-src
echo ""
echo "🧹 Cleaning up unnecessary deb-src entries..."
sed --in-place --expression "s|^deb-src|#deb-src|" /etc/apt/sources.list                                                                              

# upgrade & install some apps
echo ""
echo "🆙 Updating and upgrading the system..."
apt update && apt full-upgrade --assume-yes

echo ""
echo "📥 Installing essential tools and desktop apps..."
apt install --no-install-recommends --no-install-suggests --assume-yes \
  apt-transport-https \
  aspell-fr \
  build-essential \
  ca-certificates \
  cntlm \
  curl \
  filezilla \
  fonts-dejavu \
  fonts-lato \
  fonts-noto-color-emoji \
  fonts-noto-core \
  fonts-noto-extra \
  fonts-noto-mono \
  fonts-noto-ui-core \
  fonts-noto-ui-extra \
  fonts-open-sans \
  fonts-powerline \
  fonts-roboto \
  fonts-symbola \
  git \
  git-flow \
  gnome-themes-extra \
  gnupg-agent \
  htop \
  hunspell-fr \
  hyphen-fr \
  jq \
  libsecret-tools \
  mythes-fr \
  netcat-openbsd \
  network-manager \
  rsync \
  sshfs \
  sudo \
  terminator \
  vim \
  zsh

echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections > /dev/null
apt install --no-install-recommends --no-install-suggests --assume-yes \
  kdiff3 \
  kompare \
  wireshark

# remove uneccessary apps
# echo ""
# echo "🧽 Removing unnecessary default applications..."
apt autoremove --purge --assume-yes \
  firefox-esr \
  fonts-lklug-sinhala \
  fonts-lohit\* \
  fonts-samyak\* \
  fonts-tibetan-machine \
  fonts-tlwg\* \
  gnome-calendar \
  gnome-console \
  gnome-contacts \
  gnome-maps \
  gnome-snapshot \
  gnome-terminal \
  gnome-tour \
  gnome-weather \
  ifupdown \
  kio-audiocd \
  nano \
  netcat-traditional \
  showtime \
  simple-scan \
  skanlite \
  thunderbird \
  totem

# customization
echo ""
echo "👤 Adding a user to the sudo group..."
usermod --append --groups sudo ${USER_OVERRIDE:-$(getent passwd 1000 | cut -d: -f1)}

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
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/debian-vm/docker.sh" | bash

# falco
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/debian-vm/falco.sh" | bash

# glab
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/debian-vm/glab.sh" | bash

# google chrome
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/debian-vm/google-chrome.sh" | bash

# jetbrains-toolbox
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/debian-vm/jetbrains-toolbox.sh" | bash

# libreoffice
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/debian-vm/libreoffice.sh" | bash

# mariadb
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/debian-vm/mariadb.sh" | bash

# nginx
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/debian-vm/nginx.sh" | bash

# oc
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/debian-vm/oc.sh" | bash

# pdfsam
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/debian-vm/pdfsam.sh" | bash

# postman
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/debian-vm/postman.sh" | bash

# visual studio code
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/debian-vm/visual-studio-code.sh" | bash

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
