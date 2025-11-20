#! /bin/bash
 
# How to install a new machine

## Directory structure
mkdir -p ~/tmp
mkdir -p ~/bin
mkdir -p ~/projects
mkdir -p ~/projects/code
mkdir -p ~/projects/dotfiles

## Download dotfiles
git clone https://github.com/TomDeneire/dotfiles ~/projects/dotfiles

## General tools
### git
sudo add-apt-repository ppa:git-core/ppa -y
sudo apt-get update -y
sudo apt install git -y

### zip
sudo apt install zip -y

### fzf
sudo apt install fzf -y

### tmux
sudo apt install tmux -y
ln -s ~/.tmux.conf /home/tdeneire/projects/dotfiles/tmux/.tmux.conf

### fd-find
sudo apt install fd-find -y

### zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

### lsd
sudo apt install lsd -y

## bashrc

### atuin (including bash profile or whatever it is)

### sesh

### bat

### lazygit

## wezterm

## neovim
mkdir -p ~/projects/dotfiles/nvim

### gcc compiler
sudo apt update -y
sudo apt install build-essential -y

### npm/node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
nvm install 20.5.0

### ripgrep

### python support
sudo apt install python3-neovim


## Go
sudo add-apt-repository ppa:longsleep/golang-backports -y
sudo apt update -y
sudo apt install golang-go -y


