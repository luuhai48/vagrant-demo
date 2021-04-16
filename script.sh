#!/bin/bash

sudo apt update && apt upgrade -y && apt install -y software-properties-common

sudo wget -qO- https://get.docker.com/ | sh
sudo usermod -aG docker "${USER}"
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo apt-get install -y git zip unzip nano zsh make
sudo apt autoremove -y && apt autoclean -y 

sudo chsh -s $(which zsh) "${USER}"

curl -L git.io/antigen > ~/antigen.zsh
cat >> ~/.zshrc <<EOL
source ~/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle command-not-found

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions

# Load the theme.
antigen theme dpoggi

# Tell Antigen that you're done.
antigen apply
EOL

# create swap file
SIZE=1

sudo fallocate -l ${SIZE}G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# optimize
sudo sysctl vm.swappiness=10
sudo sysctl vm.vfs_cache_pressure=50

echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf
