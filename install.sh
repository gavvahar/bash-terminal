#!/bin/bash

set -e

INSTALL_DIR="$HOME/.config/bash-terminal"

if [[ -d "$INSTALL_DIR" ]]; then
    echo "Backing up existing bash-terminal config..."
    mv "$INSTALL_DIR" "$INSTALL_DIR.bak.$(date +%s)"
fi

git clone https://github.com/gavvahar/bash-terminal.git "$INSTALL_DIR"
echo "✅ Bash-terminal config cloned"

if [[ -f "$HOME/.bashrc" && ! -L "$HOME/.bashrc" ]]; then
    echo "Backing up existing ~/.bashrc..."
    mv "$HOME/.bashrc" "$HOME/.bashrc.bak.$(date +%s)"
fi

ln -sf "$INSTALL_DIR/.bashrc" "$HOME/.bashrc"
echo "✅ ~/.bashrc symlinked"

echo ""
echo "Done! Reload your shell:"
echo "  source ~/.bashrc"
