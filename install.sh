#!/usr/bin/env bash

set -e 

REPO_NAME="terminal-ide"
BASE_DIR="~/.config/"
mkdir -p $BASE_DIR
cd $BASE_DIR
git clone "https://github.com/leonardoifg/$REPO_NAME.git"
REPO_DIR="$BASE_DIR/terminal-ide/"

set -e

echo "🔧 Detectando seu OS..."
OS="$(uname)"

if [[ "$OS" == "Darwin" ]]; then
    echo "🍎 macOS detectado"
    brew update
    brew install neovim tmux git ripgrep fd zsh curl unzip gcc node
    cat "~/$REPO_DIR/shell/.aliases.sh" >> ~/.zshrc
elif [[ "$OS" == "Linux" ]]; then
    echo "🐧 Linux detectado"
    sudo apt update
    sudo apt install -y neovim tmux zsh git curl unzip gcc ripgrep fd-find
    cat "~/$REPO_DIR/shell/.aliases.sh" >> ~/.bashrc
fi

echo "📁 Criando symlinks..."
ln -sf "~/$REPO_DIR/tmux/.tmux.conf" ~/.tmux.conf
ln -sf "~/$REPO_DIR/nvim" ~/.config/nvim

echo "✅ Setup concluído!"
