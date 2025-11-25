#! /bin/bash

# Helper functions

print() {
    echo
    echo "-----------------------------------------------------"
    echo "$1"
    echo "-----------------------------------------------------"
}

pause() {
    echo
    local prompt="${1:-Press any key to continue...}" 
    read -n 1 -s -r -p "$prompt"
    echo
}
 
# INSTALLING A NEW TERMINAL ENVIRONMENT ON UBUNTU-BASED SYSTEMS

## Directory structure
print "Installing directory structure"
mkdir -p ~/.config
mkdir -p ~/tmp
mkdir -p ~/bin
mkdir -p ~/projects
mkdir -p ~/projects/code
mkdir -p ~/projects/dotfiles
pause

## Change to temp directory
cd ~/tmp || exit

## Update and upgrade
print "Updating and upgrading Ubuntu"
sudo apt update -y
sudo apt upgrade -y
sudo apt install software-properties-common -y
pause

## git
print "Installing git"
sudo add-apt-repository ppa:git-core/ppa -y
sudo apt update -y
sudo apt install git -y
pause

## Download dotfiles
print "Downloading dotfiles"
git clone https://github.com/TomDeneire/dotfiles ~/projects/dotfiles
pause

## Configure git
ln -sf ~/projects/dotfiles/git ~/.config/git

## Configure bash
print "Configuring bash"
rm -f ~/.bashrc
ln -sf ~/projects/dotfiles/bash/.bashrc ~/.bashrc
source ~/.bashrc
ln -sf ~/projects/dotfiles/bash/.bash-preexec.sh ~/.bash-preexec.sh
source ~/.bash-preexec.sh
ln -sf ~/projects/dotfiles/git/git-prompt.sh ~/git-prompt.sh
source ~/git-prompt.sh
pause

## General tools

### systemd
print "Installing systemd"
sudo apt install systemd -y
pause

### build tools (gcc compiler, make, ...)
print "Installing build tools"
sudo apt install build-essential -y
pause


### zip/unzip
print "Installing zip/unzip"
sudo apt install zip unzip -y
pause

### curl
print "Installing curl"
sudo apt install curl -y
pause

### wget
print "Installing wget"
sudo apt install wget -y
pause

### tmux
print "Installing tmux"
sudo apt install tmux -y
ln -s ~/projects/dotfiles/tmux/.tmux.conf ~/.tmux.conf
pause

### fzf (including fzf-tmux)
print "Installing fzf"
sudo apt install fzf -y
pause


### xsel
print "Installing xsel"
sudo apt install xsel -y
pause

### tree
print "Installing tree"
sudo apt install tree -y
pause

### jq
print "Installing jq"
sudo apt install jq -y
pause

### fdfind
print "Installing fdfind"
sudo apt install fd-find -y
ln -s $(which fdfind) ~/bin/fd
pause

### zoxide
print "Installing zoxide"
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
export PATH="$PATH:/root/.local/bin"
pause

### gio trash
print "Installing gio trash"
sudo apt install libglib2.0-bin -y
pause

### btop
print "Installing btop"
sudo apt install btop -y
ln -s ~/projects/dotfiles/btop ~/.config/btop
pause

### atuin
print "Installing atuin"
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
source $HOME/.atuin/bin/env
ln -s ~/projects/dotfiles/bash/.bash_profile ~/.bash_profile
atuin init bash
pause

### bat
print "Installing bat"
sudo apt install bat -y
ln -s ~/projects/dotfiles/bat ~/.config/bat
pause

## lazygit
print "Installing lazygit"
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
ln -s ~/projects/dotfiles/lazygit ~/.config/lazygit
ln -s $(which lg) ~/bin/lg
pause

## wezterm
print "Installing wezterm"
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
sudo apt update
sudo apt install wezterm -y
ln -s ~/projects/dotfiles/wezterm/.wezterm.lua ~/.wezterm.lua
pause

## neovim
print "Installing neovim"
sudo apt install xclip -y
mkdir -p ~/bin
curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz
tar -xzf nvim-linux-x86_64.tar.gz
mv nvim-linux-x86_64 ~/nvim
ln -s ~/nvim/bin/nvim ~/bin/nvim
git clone https://github.com/TomDeneire/nvim ~/projects/nvim
ln -s ~/projects/nvim ~/.config/nvim
pause

### npm/node
print "Installing npm/node"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
export NVM_DIR="$HOME/.nvm"
source $NVM_DIR/nvm.sh
nvm install --lts
nvm alias default lts/*
pause

### ripgrep
print "Installing ripgrep"
sudo apt install ripgrep -y
pause

### tree-sitter-cli
print "Installing tree-sitter-cli"
npm install -g tree-sitter-cli
pause

### Python support
print "Installing Python support for Neovim"
sudo apt install python3.10-venv -y  # for LSP support
sudo apt install python3-neovim -y
pause

## Docker
print "Installing Docker"
sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc | cut -f1)
### Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

### Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

### Install Docker
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
pause

## Go
print "Installing Go"
GOLATEST=$(curl https://go.dev/VERSION?m=text | grep go)".linux-amd64.tar.gz"
wget "https://go.dev/dl/$GOLATEST"
sudo rm -rf /usr/local/go 
sudo tar -C /usr/local -xzf "$GOLATEST"
env PATH="$PATH:/usr/local/go/bin"
pause

### sesh
print "Installing sesh"
mkdir -p ~/projects/code/go
git clone https://github.com/joshmedeski/sesh ~/projects/code/go/sesh
cd ~/projects/code/go/sesh && go install
pause

## Uv for Python
print "Installing uv"
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env
pause

## Rust
print "Installing Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
pause

### lsd
print "Installing lsd"
cargo install lsd
pause

## Nerdfonts
print "Installing Nerdfonts"
sudo apt install fontconfig -y
bash -c  "$(curl -fsSL https://raw.githubusercontent.com/officialrajdeepsingh/nerd-fonts-installer/main/install.sh)" 
pause

## Reactivate bash prompt
print "Reactivating bash prompt"
source ~/.bashrc
pause
