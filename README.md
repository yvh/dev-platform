# dev-platform

Basic install without desktop environment

```bash
# as root
apt install --no-install-recommends --no-install-suggests -y curl openssl ca-certificates
curl -fsSL "https://raw.githubusercontent.com/yvh/dev-platform/wsl/bootstrap.sh" | bash

# as user
git clone -b wsl https://github.com/yvh/dev-platform.git ~/workspaces/yvh/dev-platform
cd ~/workspaces/yvh/dev-platform
./install.sh
```
