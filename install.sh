#!/usr/bin/env bash
set -euo pipefail

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

echo ""
echo "📥 Installing essential tools and desktop apps..."
pacman --sync --refresh --noconfirm \
  base-devel \
  git \
  htop \
  less \
  mesa \
  nmap \
  nss \
  nvim \
  tmux \
  unzip \
  vulkan-dzn \
  wget \
  xdg-utils \
  xz

# customization
echo ""
echo "🧾 Adjusting network and terminal settings..."
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
cat > /root/.bash_profile << EOF
#
# ~/.bash_profile
#
[[ -f ~/.bashrc ]] && . ~/.bashrc
EOF

if grep --quiet "^[[:space:]]*SendEnv" /etc/ssh/ssh_config 2>/dev/null; then
  sed --in-place 's/^[[:space:]]*SendEnv/# &/g' /etc/ssh/ssh_config || true
fi

ln --symbolic --force /usr/bin/nvim /usr/bin/vi

echo ""
echo "🔧 Tuning inotify settings for IDEs..."
echo "fs.inotify.max_user_watches = 1048576" > /etc/sysctl.d/99-idea.conf
sysctl --system

echo ""
echo "✅ ‘The script has run its course... may your server never segfault again.’"
