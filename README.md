# dev-platform

Basic install


```bash
# setup locale
curl -fsSL https://raw.githubusercontent.com/yvh/dev-platform/wsl-archlinux/locale.sh | bash

# set root password and create user
passwd
useradd -m -G wheel -c "{FULLNAME}" {USERNAME}
passwd {USERNAME}
EDITOR=vim visudo # to set wheel user to use sudo

# install default apps
curl -fsSL https://raw.githubusercontent.com/yvh/dev-platform/wsl-archlinux/install.sh | bash
```

Next, view the `post-install.sh` script

```bash
git clone -b wsl-archlinux git@github.com:yvh/dev-platform.git ~/workspaces/yvh/dev-platform
```
