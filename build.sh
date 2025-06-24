#!/usr/bin/env bash

set -ex

rm --recursive --force ~/.cache/mozilla ~/.mozilla

# remove uneccessary dirs
echo "enabled=False" > ~/.config/user-dirs.conf
sed -i 's/XDG_TEMPLATES_DIR/#XDG_TEMPLATES_DIR/' ~/.config/user-dirs.dirs
sed -i 's/XDG_PUBLICSHARE_DIR/#XDG_PUBLICSHARE_DIR/' ~/.config/user-dirs.dirs
sed -i 's/XDG_DOCUMENTS_DIR/#XDG_DOCUMENTS_DIR/' ~/.config/user-dirs.dirs
sed -i 's/XDG_MUSIC_DIR/#XDG_MUSIC_DIR/' ~/.config/user-dirs.dirs
sed -i 's/XDG_PICTURES_DIR/#XDG_PICTURES_DIR/' ~/.config/user-dirs.dirs
sed -i 's/XDG_VIDEOS_DIR=/#XDG_VIDEOS_DIR=/' ~/.config/user-dirs.dirs

# oh-my-zsh
set +x
sh -c "$(curl --silent --show-error --location https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
