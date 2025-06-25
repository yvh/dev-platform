#!/usr/bin/env bash

# /tmp to tmpfs
echo ""
echo "🧼 Mounting /tmp in memory (tmpfs)..."
sudo cp /usr/share/systemd/tmp.mount /etc/systemd/system/
sudo systemctl enable --now tmp.mount

echo ""
echo "🧼 Disable apt-esm-hook..."
sudo dpkg-divert --rename --divert /etc/apt/apt.conf.d/20apt-esm-hook.conf.disabled --add /etc/apt/apt.conf.d/20apt-esm-hook.conf

# locale
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/ubuntu-24.04-vm/locale.sh" | bash

# upgrade & install some apps
echo ""
echo "🆙 Updating and upgrading the system..."
sudo apt update && sudo apt full-upgrade --assume-yes

echo ""
echo "📥 Installing essential tools and desktop apps..."
sudo apt install --assume-yes build-essential apt-transport-https ca-certificates gnupg-agent software-properties-common \
    vim curl sshfs htop zsh filezilla cntlm jq terminator \
    fonts-dejavu fonts-lato fonts-open-sans fonts-roboto fonts-powerline ttf-mscorefonts-installer \
    aspell-fr hyphen-fr mythes-fr hunspell-fr
sudo apt install --assume-yes --no-install-recommends kdiff3 wireshark kompare

# remove snapd
echo ""
echo "🧽 Removing snapd..."
sudo snap remove firefox gnome-42-2204
sudo snap remove gtk-common-themes
sudo snap remove snapd-desktop-integration
sudo snap remove snap-store
sudo snap remove firmware-updater
sudo snap remove core22
sudo snap remove bare
sudo snap remove snapd
sudo apt -y autoremove --purge snapd
rm -rf ~/snap ~/Downloads/firefox.tmp

# remove uneccessary apps
echo ""
echo "🧽 Removing unnecessary default applications..."
sudo apt-get purge --assume-yes fonts-lohit* fonts-tlwg* fonts-samyak* fonts-tibetan-machine fonts-lklug-sinhala nano \
    firefox firefox-locale-en skanlite kio-audiocd thunderbird
sudo apt autoremove --purge --assume-yes
rm --recursive --force ~/.cache/mozilla ~/.mozilla

# customization
echo ""
echo "🧾 Adjusting settings..."
sudo update-alternatives --set editor /usr/bin/vim.basic
sudo sed --in-place 's/#force_color_prompt=yes/force_color_prompt=yes/' /root/.bashrc
sudo sed --in-place 's/01;32m/01;31m/' /root/.bashrc
sudo sed --in-place 's/    SendEnv/#   SendEnv/g' /etc/ssh/ssh_config
sudo sh -c 'echo ".host:/ /mnt/hgfs fuse.vmhgfs-fuse defaults,allow_other 0 0" >> /etc/fstab'

# docker
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/ubuntu-24.04-vm/docker.sh" | bash

# falco
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/ubuntu-24.04-vm/falco.sh" | bash

# git
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/ubuntu-24.04-vm/git.sh" | bash

# glab
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/ubuntu-24.04-vm/glab.sh" | bash

# google chrome
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/ubuntu-24.04-vm/google-chrome.sh" | bash

# jetbrains-toolbox
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/ubuntu-24.04-vm/jetbrains-toolbox.sh" | bash

# libreoffice
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/ubuntu-24.04-vm/libreoffice.sh" | bash

# mariadb
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/ubuntu-24.04-vm/mariadb.sh" | bash

# oc
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/ubuntu-24.04-vm/oc.sh" | bash

# pdfsam
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/ubuntu-24.04-vm/pdfsam.sh" | bash

# postman
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/ubuntu-24.04-vm/postman.sh" | bash

# visual studio code
echo ""
curl --silent --show-error --fail --location "https://raw.githubusercontent.com/yvh/dev-platform/ubuntu-24.04-vm/visual-studio-code.sh" | bash

# change inotify for idea (phpstorm)
echo ""
echo "🔧 Tuning inotify settings for IDEs..."
sudo sh -c 'echo "fs.inotify.max_user_watches = 1048576" > /etc/sysctl.d/99-idea.conf'
sudo sysctl --load --system

# full-upgrade
echo ""
echo "🔁 Final system upgrade and cleanup..."
sudo apt full-upgrade --assume-yes
sudo apt autoremove --purge --assume-yes

# oh-my-zsh
echo ""
echo "📬 Installing Oh My ZSH!..."
sh -c "$(curl --silent --show-error --fail --location https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

