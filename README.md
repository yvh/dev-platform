# dev-platform

```bash
curl --silent --show-error --location "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xe1dd270288b4e6030699e45fa1715d88e1df1f24" | sudo gpg --dearmor --output /etc/apt/keyrings/git.gpg
echo "Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/git.gpg
URIs: https://ppa.launchpadcontent.net/git-core/ppa/ubuntu
Suites: $(lsb_release --codename --short)
Components: main" | sudo tee /etc/apt/sources.list.d/git.sources
sudo apt update && sudo apt install --assume-yes git

mkdir --parents ~/Workspaces/yvh
cd ~/Workspaces/yvh
git clone git@github.com:yvh/dev-platform

cd ~/Workspaces/yvh/dev-platform
./install-locale.sh # reboot after
./build.sh
```
