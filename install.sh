#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo --preserve-env bash "$0" "$@"
fi

echo ""
echo "🧙 ‘Ah... you are root. A power not to be taken lightly.’"
echo "📜 Summoning the script from the archives of GitHub..."
echo ""

export DEBIAN_FRONTEND=noninteractive
                                                                            
echo ""
echo "📥 Installing essential tools and desktop apps..."
apt install --no-install-recommends --no-install-suggests --assume-yes \
  apt-transport-https \
  bash-completion \
  bat \
  build-essential \
  eza \
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
  gnome-themes-extra \
  htop \
  jq \
  kdiff3 \
  kompare \
  netcat-openbsd \
  rsync \
  sshfs \
  terminator \
  vim \
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
echo "🧾 Adjusting terminal settings..."
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
./glab.sh

echo ""
./mariadb.sh

echo ""
./mkcert.sh

echo ""
./oc.sh

echo ""
./stunnel.sh

echo ""
echo "🔁 Final system upgrade and cleanup..."
apt full-upgrade --assume-yes
apt autoremove --purge --assume-yes

echo ""
echo "✅ ‘The script has run its course... may your server never segfault again.’"
