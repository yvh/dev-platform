#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    exit
fi

# locale
sh -c "$(curl --silent --show-error --location https://raw.githubusercontent.com/yvh/dev-platform/refs/heads/debian-vm/locale.sh)"

# /tmp to tmpfs
cp /usr/share/systemd/tmp.mount /etc/systemd/system/
systemctl enable --now tmp.mount

# remove deb-src
sed --in-place --expression "s|^deb-src|#deb-src|" /etc/apt/sources.list                                                                              

# enable backports
echo "Types: deb
Architectures: amd64
URIs: http://deb.debian.org/debian
Suites: bookworm-backports
Components: main contrib non-free non-free-firmware" | tee /etc/apt/sources.list.d/debian-backports.sources

echo "Package: *
Pin: release n=bookworm-backports
Pin-Priority: 900" | tee /etc/apt/preferences.d/99-backports

# upgrade & install some apps
apt update && apt full-upgrade --assume-yes
apt install --assume-yes build-essential apt-transport-https ca-certificates gnupg-agent software-properties-common \
    gnome-core open-vm-tools-desktop sudo curl git \
    vim sshfs htop zsh filezilla cntlm jq terminator netcat-openbsd rsync \
    fonts-dejavu fonts-lato fonts-open-sans fonts-roboto fonts-powerline \
    aspell-fr hyphen-fr mythes-fr hunspell-fr
apt install --assume-yes --no-install-recommends kdiff3 wireshark kompare

# remove uneccessary apps
apt-get purge --assume-yes fonts-lohit* fonts-tlwg* fonts-samyak* fonts-tibetan-machine fonts-lklug-sinhala nano \
    firefox-esr skanlite kio-audiocd thunderbird totem gnome-contacts gnome-online-accounts netcat-traditional \
    gnome-terminal
apt autoremove --purge --assume-yes

# customization
echo "Which user must be added to sudoers group?"
read sudoers_user
usermod --append --groups sudo $sudoers_user

rm /etc/network/interfaces
sed --in-place 's/#force_color_prompt=yes/force_color_prompt=yes/' /root/.bashrc
sed --in-place 's/01;32m/01;31m/' /root/.bashrc
sed --in-place 's/    SendEnv/#   SendEnv/g' /etc/ssh/ssh_config
sed --in-place '/dev\/sr0/d' /etc/fstab
sh -c 'echo ".host:/ /mnt/hgfs fuse.vmhgfs-fuse defaults,allow_other 0 0" >> /etc/fstab'

# docker
sh -c "$(curl --silent --show-error --location https://raw.githubusercontent.com/yvh/dev-platform/refs/heads/debian-vm/docker.sh)"

# falco
sh -c "$(curl --silent --show-error --location https://raw.githubusercontent.com/yvh/dev-platform/refs/heads/debian-vm/falco.sh)"

# glab
sh -c "$(curl --silent --show-error --location https://raw.githubusercontent.com/yvh/dev-platform/refs/heads/debian-vm/glab.sh)"

# google chrome
sh -c "$(curl --silent --show-error --location https://raw.githubusercontent.com/yvh/dev-platform/refs/heads/debian-vm/google-chrome.sh)"

# libreoffice
sh -c "$(curl --silent --show-error --location https://raw.githubusercontent.com/yvh/dev-platform/refs/heads/debian-vm/libreoffice.sh)"

# mariadb
sh -c "$(curl --silent --show-error --location https://raw.githubusercontent.com/yvh/dev-platform/refs/heads/debian-vm/mariadb.sh)"

# oc
sh -c "$(curl --silent --show-error --location https://raw.githubusercontent.com/yvh/dev-platform/refs/heads/debian-vm/oc.sh)"

# pdfsam
sh -c "$(curl --silent --show-error --location https://raw.githubusercontent.com/yvh/dev-platform/refs/heads/debian-vm/pdfsam.sh)"

# phpstorm
sh -c "$(curl --silent --show-error --location https://raw.githubusercontent.com/yvh/dev-platform/refs/heads/debian-vm/phpstorm.sh)"

# postman
sh -c "$(curl --silent --show-error --location https://raw.githubusercontent.com/yvh/dev-platform/refs/heads/debian-vm/postman.sh)"

# pycharm
sh -c "$(curl --silent --show-error --location https://raw.githubusercontent.com/yvh/dev-platform/refs/heads/debian-vm/pycharm.sh)"

# visual studio code
sh -c "$(curl --silent --show-error --location https://raw.githubusercontent.com/yvh/dev-platform/refs/heads/debian-vm/visual-studio-code.sh)"

# change inotify for idea (phpstorm)
sh -c 'echo "fs.inotify.max_user_watches = 1048576" > /etc/sysctl.d/99-idea.conf'
sysctl --load --system

# full-upgrade
apt full-upgrade --assume-yes
apt autoremove --purge --assume-yes

echo "\nYou can reboot now!"
