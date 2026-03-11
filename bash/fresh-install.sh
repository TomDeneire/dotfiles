#! /bin/bash
set -euo pipefail

# Helper functions

print_header() {
    echo
    echo "-----------------------------------------------------"
    echo "$1"
    echo "-----------------------------------------------------"
}

# INSTALLING A NEW TERMINAL ENVIRONMENT ON UBUNTU-BASED SYSTEMS

## Directory structure
print_header "Installing directory structure"
mkdir -p "$HOME/.config" "$HOME/tmp" "$HOME/bin" "$HOME/projects/code" "$HOME/projects/dotfiles"

## Change to temp directory
cd "$HOME/tmp" || exit

## Update and upgrade
print_header "Updating and upgrading Ubuntu"
sudo apt update -y
sudo apt upgrade -y

## git
print_header "Installing git"
sudo add-apt-repository ppa:git-core/ppa -y
sudo apt update -y
sudo apt install git -y

## Download dotfiles
print_header "Downloading dotfiles"
git clone https://github.com/TomDeneire/dotfiles "$HOME/projects/dotfiles"

## Configure git
ln -sf "$HOME/projects/dotfiles/git" "$HOME/.config/git"

## Configure bash
print_header "Configuring bash"
rm -f "$HOME/.bashrc"
ln -sf "$HOME/projects/dotfiles/bash/.bashrc" "$HOME/.bashrc"
ln -sf "$HOME/projects/dotfiles/bash/.bash-preexec.sh" "$HOME/.bash-preexec.sh"

## General tools
print_header "Installing general tools"
sudo apt install -y \
    software-properties-common \
    systemd \
    build-essential \
    zip unzip \
    curl \
    wget \
    tmux \
    fzf \
    xsel \
    tree \
    jq \
    fd-find \
    libglib2.0-bin \
    btop \
    bat \
    ripgrep \
    xclip \
    fontconfig

### tmux config
ln -sf "$HOME/projects/dotfiles/tmux/.tmux.conf" "$HOME/.tmux.conf"

### fdfind symlink
ln -sf "$(which fdfind)" "$HOME/bin/fd"

### btop config
ln -sf "$HOME/projects/dotfiles/btop" "$HOME/.config/btop"

### bat config
ln -sf "$HOME/projects/dotfiles/bat" "$HOME/.config/bat"

### zoxide
print_header "Installing zoxide"
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
export PATH="$PATH:$HOME/.local/bin"

### atuin
print_header "Installing atuin"
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
source "$HOME/.atuin/bin/env"
ln -sf "$HOME/projects/dotfiles/bash/.bash_profile" "$HOME/.bash_profile"

## lazygit
print_header "Installing lazygit"
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
ln -sf "$HOME/projects/dotfiles/lazygit" "$HOME/.config/lazygit"
ln -sf "$(which lazygit)" "$HOME/bin/lg"

## wezterm
print_header "Installing wezterm"
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
sudo apt update
sudo apt install wezterm -y
ln -sf "$HOME/projects/dotfiles/wezterm/.wezterm.lua" "$HOME/.wezterm.lua"

## neovim
print_header "Installing neovim"
curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz
tar -xzf nvim-linux-x86_64.tar.gz
mv nvim-linux-x86_64 "$HOME/nvim"
ln -sf "$HOME/nvim/bin/nvim" "$HOME/bin/nvim"
git clone https://github.com/TomDeneire/nvim "$HOME/projects/nvim"
ln -sf "$HOME/projects/nvim" "$HOME/.config/nvim"

### npm/node
print_header "Installing npm/node"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"
nvm install --lts
nvm alias default lts/*

### tree-sitter-cli
print_header "Installing tree-sitter-cli"
npm install -g tree-sitter-cli

### Python support
print_header "Installing Python support for Neovim"
sudo apt install python3-venv -y  # for LSP support
pip install pynvim

## Docker
print_header "Installing Docker"
sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc 2>/dev/null | cut -f1) 2>/dev/null || true
### Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl -y
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
print_header "Installing Go"
GOLATEST=$(curl https://go.dev/VERSION?m=text | grep go)".linux-amd64.tar.gz"
wget "https://go.dev/dl/$GOLATEST"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "$GOLATEST"
export PATH="$PATH:/usr/local/go/bin"

### sesh
print_header "Installing sesh"
mkdir -p "$HOME/projects/code/go"
git clone https://github.com/joshmedeski/sesh "$HOME/projects/code/go/sesh"
(cd "$HOME/projects/code/go/sesh" && go install)

## Uv for Python
print_header "Installing uv"
curl -LsSf https://astral.sh/uv/install.sh | sh

## Rust
print_header "Installing Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

### lsd
print_header "Installing lsd"
cargo install lsd

## Nerdfonts
print_header "Installing Nerdfonts"
bash -c  "$(curl -fsSL https://raw.githubusercontent.com/officialrajdeepsingh/nerd-fonts-installer/main/install.sh)"

## Clean up temp files
print_header "Cleaning up"
rm -f "$HOME/tmp/lazygit.tar.gz" "$HOME/tmp/lazygit"
rm -f "$HOME/tmp/nvim-linux-x86_64.tar.gz"
rm -f "$HOME/tmp/$GOLATEST"
