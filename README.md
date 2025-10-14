# dev-platform

Basic install without desktop environment

```bash
# as root
apt install --no-install-recommends --no-install-suggests -y curl
curl -fsSL "https://raw.githubusercontent.com/yvh/dev-platform/debian-vm/boostrap.sh" | bash

# as user
mkdir -p ~/Workspaces/yvh
git clone -b debian-vm https://github.com/yvh/dev-platform.git ~/Workspaces/yvh/dev-platform
cd ~/Workspaces/yvh/dev-platform
su -c "./install.sh"

# override default user if uid != 1000
USER_OVERRIDE=<user> su -c "./install.sh"
```
