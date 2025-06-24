# dev-platform

Basic install without desktop environment

```bash
# As root
sh -c "$(curl --silent --show-error --location https://raw.githubusercontent.com/yvh/dev-platform/refs/heads/debian-vm/init.sh)"
reboot

# As user
mkdir --parents ~/Workspaces/yvh
cd ~/Workspaces/yvh
git clone git@github.com:yvh/dev-platform

cd ~/Workspaces/yvh/dev-platform
./locale.sh
./build.sh
```
