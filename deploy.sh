#!/bin/bash
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
BLUE='\033[1;36m'
NC='\033[0m' # No Color

# ATOM
wget -P temp https://atom.io/download/deb
sudo dpkg -i temp/deb
rm -R temp

# SPOTIFY
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0DF731E45CE24F27EEEB1450EFDC8610341D9410
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update
sudo apt-get install spotify-client -y

# GOOGLE CHROME
sudo apt install -y libxss1 libappindicator1 libindicator7
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome*.deb
rm google-chrome*.deb

# Divers tools
sudo apt install nmap tree htop zsh tmux -y
# Slack
sudo snap install slack --classic

#CONFIGURE GITHUB
git config --global user.name "Lucas Maurice"
git config --global user.email "lucas.maurice@outlook.com"
#NEXT ARE FOR SSH LOGIN CONFIGURATION ON GITHUB
ssh-keygen -t rsa -b 4096 -C "lucas.maurice@outlook.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
#cat ~/.ssh/id_rsa.pub
#echo "Now go in your GitHub Settings and copy/paste your SSH key."

# Settings TMUX
cp dotfiles/tmux.conf ~/.tmux.conf

# AUTO DEPLOYMENT - INSTALL
echo -e "${GREEN}Deployment:${NC} Installation of contents in ./installers."
for f in `ls ./installers/*.sh `
do
    echo -e "${RED}Installation:${NC} $(echo $f | cut --delimiter='/' --fields=3 | cut --delimiter='.' --fields=1)"
    ${f}
done

# AUTO DEPLOYMENT - CONFIG
echo -e "${GREEN}Deployment:${NC} Installation of dotfiles in ./dotfiles"
for f in `ls ./dotfiles`
do
    echo -e "${YELLOW}Config:${NC} $(echo $f | cut --delimiter='/' --fields=3)"
    if [ -d ./dotfiles/${f} ]; then
        mkdir -p ~/.${f}
        cp -f -r ./dotfiles/${f}/* ~/.${f}
    else
        cp ./dotfiles/${f} ~/.${f}
    fi
done

# Settings ZSH
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
