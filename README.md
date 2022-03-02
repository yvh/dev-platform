# dev-platform

```bash
#sudo add-apt-repository -y ppa:git-core/ppa
sudo apt-key --keyring /etc/apt/trusted.gpg.d/git.gpg adv --keyserver keyserver.ubuntu.com --recv-key E1DD270288B4E6030699E45FA1715D88E1DF1F24
sudo sh -c 'echo "deb https://ppa.launchpadcontent.net/git-core/ppa/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/git.list'
sudo sh -c 'echo "#deb-src https://ppa.launchpadcontent.net/git-core/ppa/ubuntu $(lsb_release -cs) main" >> /etc/apt/sources.list.d/git.list'
sudo apt install -y git

mkdir -p ~/Projects/yvh
cd ~/Projects/yvh
git clone git@github.com:yvh/dev-platform

cd ~/Projects/yvh/dev-platform
./build-locale.sh # reboot after
./build-env.sh
```
