# dev-platform

Basic install


```bash
# setup locale
curl -fsSL https://raw.githubusercontent.com/yvh/dev-platform/archlinux/locale.sh | bash

# setup efibootmgn and networkmanager
curl -fsSL https://raw.githubusercontent.com/yvh/dev-platform/archlinux/efibootmgr.sh | bash
# set efibootlaoder 
efibootmgr --create --disk /dev/nvme0n1 --part 1 --label "Arch Linux" --loader '\EFI\Linux\arch-linux.efi' --unicode

# set root password and create user
passwd
useradd -m -G wheel -c "{FULLNAME}" {USERNAME}
passwd {USERNAME}
EDITOR=vim visudo # to set wheel user to use sudo

# install kde desktop
curl -fsSL https://raw.githubusercontent.com/yvh/dev-platform/archlinux/install.sh | bash
```

Next, view the `post-install.sh` script
