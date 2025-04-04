# dev-platform

Basic install without desktop environment

```bash
# As root
apt update && apt install --assume-yes gnome-core open-vm-tools-desktop sudo curl git
echo "Which user must be added to sudoers group?"
read sudoers_user
usermod --append --groups sudo $sudoers_user
rm /etc/network/interfaces
reboot

# As user
mkdir --parents ~/Workspaces/yvh
cd ~/Workspaces/yvh
git clone git@github.com:yvh/dev-platform

cd ~/Workspaces/yvh/dev-platform
./locale.sh
./build.sh
```
