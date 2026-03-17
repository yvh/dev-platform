#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo -E bash "$0" "$@"
fi

echo "🌍 Setting system locale..."
curl --silent --show-error --fail --location --output /usr/share/i18n/locales/en_BE "https://gist.githubusercontent.com/yvh/630368018d7c683aca8da9e2baf7bfb9/raw/48d0bf07c296fabb8d927317e2a1ac0a271c313b/en_BE"
localedef --inputfile en_BE --charmap UTF-8 --force en_BE

sed --in-place --expression "s|^#en_US\.UTF-8|en_US.UTF-8|" /etc/locale.gen
sed --in-place --expression "s|^#fr_BE\.UTF-8|fr_BE.UTF-8|" /etc/locale.gen
sed --in-place --expression "/#en_BW\.UTF-8.*/a en_BE.UTF-8 UTF-8" /etc/locale.gen

cat > /etc/locale.conf << 'EOF'
LANG=en_US.UTF-8
LC_ADDRESS=en_BE.UTF-8
LC_MEASUREMENT=en_BE.UTF-8
LC_MONETARY=en_BE.UTF-8
LC_NUMERIC=en_BE.UTF-8
LC_PAPER=en_BE.UTF-8
LC_TELEPHONE=en_BE.UTF-8
LC_TIME=en_BE.UTF-8
EOF

cat > /etc/vconsole.conf << 'EOF'
KEYMAP=be-latin1
EOF

locale-gen
