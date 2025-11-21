#! /bin/bash
 
# Installing a new terminal environment on Ubuntu-based systems

## Directory structure
mkdir -p ~/tmp
mkdir -p ~/bin
mkdir -p ~/projects
mkdir -p ~/projects/code
mkdir -p ~/projects/dotfiles

## Change to temp directory
cd ~/tmp || exit

## Download dotfiles
git clone https://github.com/TomDeneire/dotfiles ~/projects/dotfiles

## General tools
### update and upgrade
sudo apt update -y
sudo apt upgrade -y

### gcc compiler + make
sudo apt install build-essential -y

### git
sudo add-apt-repository ppa:git-core/ppa -y
sudo apt install git -y

### zip/unzip
sudo apt install zip unzip -y

### curl
sudo apt install curl -y

### fzf
sudo apt install fzf -y

### tmux
sudo apt install tmux -y
ln -s ~/.tmux.conf ~/projects/dotfiles/tmux/.tmux.conf

### fd-find
sudo apt install fd-find -y

### zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

### lsd
sudo apt install lsd -y

## bashrc
ln -s ~/.bashrc ~/projects/dotfiles/bash/.bashrc
ln -s ~/.bash-preexec.sh ~/projects/dotfiles/bash/.bash-preexec.sh
ln -s ~/git-prompt.sh ~/projects/dotfiles/git/git-prompt.sh

### atuin
ln -s ~/.bash_profile ~/projects/dotfiles/bash/.bash_profile
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
atuin init

### bat
apt install bat -y

### lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
ln -s ~/.config/lazygit ~/projects/dotfiles/lazygit

## wezterm
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
sudo apt install wezterm -y
ln -s ~/.wezterm.lua ~/projects/dotfiles/wezterm/.wezterm.lua

## neovim
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install xclip -y
sudo apt install neovim -y
git clone https://github.com/TomDeneire/nvim ~/projects/nvim
ln -s ~/.config/nvim ~/projects/nvim

### npm/node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
nvm install --lts

### ripgrep
sudo apt install ripgrep -y

### python support
sudo apt install python3-neovim -y

## Docker
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

## Go
sudo add-apt-repository ppa:longsleep/golang-backports -y
sudo apt update -y
sudo apt install golang-go -y

### sesh
mkdir -p ~/projects/code/go
git clone https://github.com/joshmedeski/sesh ~/projects/code/go/sesh
cd ~/projects/code/go/sesh && go install

## Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

## Nerdfonts
bash -c  "$(curl -fsSL https://raw.githubusercontent.com/officialrajdeepsingh/nerd-fonts-installer/main/install.sh)" 
