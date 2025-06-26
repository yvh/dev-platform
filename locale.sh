#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then
  echo ""
  echo "⚠️  ‘You are not root, young hobbit...’"
  echo "👑 Elevating your privileges... like a true wizard."
  echo ""
  exec sudo bash "$0" "$@"
fi

echo "🌍 Setting system locale..."
curl --silent --show-error --fail --location --output /tmp/en_BE "https://gist.githubusercontent.com/yvh/630368018d7c683aca8da9e2baf7bfb9/raw/48d0bf07c296fabb8d927317e2a1ac0a271c313b/en_BE"
cp /tmp/en_BE /usr/share/i18n/locales/en_BE
localedef -i en_BE -c -f UTF-8 en_BE

sed --in-place '$d' /etc/locale.gen
sed --in-place --expression "s|^de_BE\.UTF-8|# de_BE.UTF-8|" /etc/locale.gen
sed --in-place --expression "s|^nl_BE\.UTF-8|# nl_BE.UTF-8|" /etc/locale.gen
sed --in-place --expression "s|^# en_GB\.UTF-8|en_GB.UTF-8|" /etc/locale.gen
sed --in-place --expression "s|^# en_US\.UTF-8|en_US.UTF-8|" /etc/locale.gen
sed --in-place --expression "s|^# fr_BE\.UTF-8|fr_BE.UTF-8|" /etc/locale.gen
sed --in-place --expression "/# en_BW\.UTF-8.*/a en_BE.UTF-8 UTF-8" /etc/locale.gen
sed --in-place --expression "/LANGUAGE=.*/a LC_MESSAGES=C.UTF-8" /etc/default/locale

locale-gen
