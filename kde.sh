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
echo "📥 Install essential packages and KDE components..."
apt install --no-install-recommends --no-install-suggests --assume-yes \
    7zip \
    aha \
    ark \
    aspell-en \
    bluedevil \
    breeze-gtk-theme \
    clinfo \
    exfatprogs \
    ffmpegthumbs \
    fprintd \
    ghostscript \
    gnupg-agent \
    gnupg-utils \
    gpgv \
    grub-theme-breeze \
    gwenview \
    hunspell \
    hunspell-en-us \
    hunspell-fr \
    kate \
    kde-config-gtk-style \
    kde-config-plymouth \
    kde-config-screenlocker \
    kde-config-sddm \
    kde-plasma-desktop \
    kde-spectacle \
    kde-style-breeze \
    kdegraphics-thumbnailers \
    kinfocenter \
    kio-fuse \
    kmenuedit \
    konsole \
    kpackagetool6 \
    kscreen \
    ksshaskpass \
    kwalletmanager \
    kwin-x11 \
    libcamera-ipa \
    libcanberra-pulse \
    libdisplay-info-bin \
    libkf6dbusaddons-bin \
    libkf6guiaddons-bin \
    libkf6iconthemes-bin \
    libkf6kcmutils-bin \
    libpam-fprintd \
    libpam-kwallet5 \
    libpaper-utils \
    libproxy-tools \
    libqca-qt6-plugins \
    librsvg2-common \
    mesa-utils \
    ntfs-3g \
    okular \
    pipewire-alsa \
    pipewire-audio \
    pipewire-libcamera \
    plasma-activities-bin \
    plasma-nm \
    plasma-pa \
    plasma-systemmonitor \
    plasma-thunderbolt \
    plymouth \
    plymouth-label \
    plymouth-theme-breeze \
    powerdevil \
    qt6-gtk-platformtheme \
    qt6-image-formats-plugin-pdf \
    qt6-image-formats-plugins \
    qt6-qpa-plugins \
    rtkit \
    sddm-theme-breeze \
    systemsettings \
    unzip \
    wayland-utils \
    xdg-utils \
    xsettings-kde \
    xwaylandvideobridge \
    xz-utils \
    zip

apt install --install-recommends --assume-yes \
    fwupd \
    kio-extras

sed --in-place '/^GRUB_CMDLINE_LINUX_DEFAULT=/ s/"$/ splash"/' /etc/default/grub
sed --in-place '/^GRUB_CMDLINE_LINUX=/a GRUB_THEME="/usr/share/grub/themes/breeze/theme.txt"' /etc/default/grub
sed --in-place 's/^GRUB_GFXMODE=.*/GRUB_GFXMODE=1920x1200/' /etc/default/grub
sed --in-place '/^GRUB_GFXMODE=/a GRUB_GFXPAYLOAD_LINUX=keep' /etc/default/grub
sed --in-place 's|global\.title\.text = "Debian GNU/Linux trixie/sid ";|global.title.text = "Debian GNU/Linux trixie";|' /usr/share/plymouth/themes/breeze/breeze.script
plymouth-set-default-theme breeze
plymouth-set-default-theme --rebuild-initrd
update-grub
