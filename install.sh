#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo -E bash "$0" "$@"
fi

echo ""
echo "🧙 ‘Ah... you are root. A power not to be taken lightly.’"
echo "📜 Summoning the script from the archives of GitHub..."
echo ""

export DEBIAN_FRONTEND=noninteractive

echo ""
./kde.sh
                                                                            
echo ""
echo "📥 Installing essential tools and desktop apps..."
echo "wireshark-common wireshark-common/install-setuid boolean true" | debconf-set-selections > /dev/null
apt install --no-install-recommends --no-install-suggests --assume-yes \
  apt-transport-https \
  aspell-fr \
  bat \
  build-essential \
  ca-certificates \
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
  git-delta \
  git-flow \
  gnupg-agent \
  htop \
  hunspell-fr \
  hyphen-fr \
  jq \
  kdiff3 \
  kompare \
  libsecret-tools \
  mythes-fr \
  netcat-openbsd \
  rsync \
  sshfs \
  sudo \
  tree \
  vim \
  wireshark \
  zsh

echo ""
echo "🧽 Removing unnecessary default applications..."
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
echo "🧾 Adjusting network and terminal settings..."
if [ -f /etc/network/interfaces ]; then
  rm -f /etc/network/interfaces
fi

cat > /root/.bashrc << EOF
PS1='\[\e[1;31m\]\u@\h:\w# \[\e[0m\]'
alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias ls='ls --color=tty'
alias lsa='ls -lah'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
EOF

if grep -q "^[[:space:]]*SendEnv" /etc/ssh/ssh_config 2>/dev/null; then
  sed --in-place 's/^[[:space:]]*SendEnv/# &/g' /etc/ssh/ssh_config || true
fi

echo ""
./docker.sh

echo ""
./eza.sh

echo ""
./glab.sh

echo ""
./google-chrome.sh

echo ""
./jetbrains-toolbox.sh

echo ""
./libreoffice.sh

echo ""
./mariadb.sh

echo ""
./mkcert.sh

echo ""
./nginx.sh

echo ""
./oc.sh

echo ""
./pdfsam.sh

echo ""
./postman.sh

echo ""
./stunnel.sh

echo ""
./visual-studio-code.sh

echo ""
echo "🔧 Tuning inotify settings for IDEs..."
echo "fs.inotify.max_user_watches = 1048576" > /etc/sysctl.d/99-idea.conf
sysctl --load --system

echo ""
echo "🔁 Final system upgrade and cleanup..."
apt full-upgrade --assume-yes
apt autoremove --purge --assume-yes

echo ""
echo "✅ ‘The script has run its course... may your server never segfault again.’"
