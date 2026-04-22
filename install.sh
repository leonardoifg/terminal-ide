#!/usr/bin/env bash

set -e 

REPO_NAME="terminal-ide"
BASE_DIR="$HOME/.config/"
REPO_DIR="$BASE_DIR/terminal-ide/"
if [ ! -d "$BASE_DIR" ]; then
    mkdir -p $BASE_DIR
fi
if [ ! -d "$REPO_DIR" ]; then
    cd $BASE_DIR
    git clone "https://github.com/leonardoifg/$REPO_NAME.git"
fi

INSTALL=false
if [ "$1" = "--install" ]; then
    INSTALL=true
fi

echo "🔧 Detectando seu OS..."
OS="$(uname)"

if [[ "$OS" == "Darwin" ]]; then
    echo "🍎 macOS detectado"
    brew update
    brew install neovim tmux git ripgrep fd zsh curl unzip gcc node
    cat "$REPO_DIR/shell/.aliases.sh" >> ~/.zshrc
elif [[ "$OS" == "Linux" ]]; then
    echo "🐧 Linux detectado"
    if $INSTALL; then
        sudo apt update
        sudo apt install -y neovim tmux zsh git curl unzip gcc ripgrep fd-find
    else
        echo "Rode:"
	echo "sudo apt update"
	echo "sudo apt install -y neovim tmux zsh git curl unzip gcc ripgrep fd-find"
    fi
    cat "$REPO_DIR/shell/.aliases.sh" >> ~/.bashrc
fi

echo "📁 Criando symlinks..."
ln -sf "$REPO_DIR/tmux/.tmux.conf" ~/.tmux.conf
ln -sf "$REPO_DIR/nvim" ~/.config/nvim

echo "✅ Setup concluído!"
