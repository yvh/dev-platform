# dev-platform

```bash
curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xe1dd270288b4e6030699e45fa1715d88e1df1f24" | sudo gpg --dearmor -o /etc/apt/keyrings/git.gpg
echo "Types: deb
Architectures: amd64
Signed-By: /etc/apt/keyrings/git.gpg
URIs: https://ppa.launchpadcontent.net/git-core/ppa/ubuntu
Suites: $(lsb_release -cs)
Components: main" | sudo tee /etc/apt/sources.list.d/git.sources
sudo apt update && sudo apt install -y git

mkdir -p ~/Projects/yvh
cd ~/Projects/yvh
git clone git@github.com:yvh/dev-platform

cd ~/Projects/yvh/dev-platform
./build-locale.sh # reboot after
./build-env.sh
```
