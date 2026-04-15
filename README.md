# dev-platform

Basic install

```bash
pacstrap -K /mnt base linux linux-firmware nvim less

# after mount
ln -s /usr/bin/nvim /usr/bin/vi
ln -s /usr/bin/nvim /usr/bin/vim

# setup locale
curl -fsSL https://raw.githubusercontent.com/yvh/dev-platform/archlinux-vm/locale.sh | bash

# setup efibootmgn and networkmanager
curl -fsSL https://raw.githubusercontent.com/yvh/dev-platform/archlinux-vm/efibootmgr.sh | bash
# set efibootlaoder 
efibootmgr --create --disk /dev/nvme0n1 --part 1 --label "Arch Linux" --loader '\EFI\Linux\arch-linux.efi' --unicode

# set root password and create user
passwd
useradd -m -G wheel -c "{FULLNAME}" {USERNAME}
passwd {USERNAME}
EDITOR=vi visudo # to set wheel user to use sudo

# install gnome desktop
curl -fsSL https://raw.githubusercontent.com/yvh/dev-platform/archlinux-vm/install.sh | bash

git clone -b archlinux-vm git@github.com:yvh/dev-platform ~/Workspaces/yvh/dev-platform
```

Next, view the `post-install.sh` script
