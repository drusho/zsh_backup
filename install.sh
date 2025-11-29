#!/bin/zsh

# This script sets up symlinks and installs iTerm2 preferences.
# It should be run from within the ~/.dotfiles directory.

echo "Creating symlinks for Zsh configuration files..."
ln -sfn ~/.dotfiles/.zshrc ~/.zshrc
ln -sfn ~/.dotfiles/.p10k.zsh ~/.p10k.zsh

echo "Creating symlink for tmux configuration..."
ln -sfn ~/.dotfiles/.tmux.conf ~/.tmux.conf

echo "Installing iTerm2 color scheme..."
# This command tells macOS to open the .itermcolors file,
# which prompts iTerm2 to install it.
open ~/.dotfiles/Cobalt2.itermcolors

echo "Installing tmux plugin manager (TPM)..."
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo "TPM installed. Run 'prefix + I' in tmux to install plugins."
else
    echo "TPM already installed."
fi

echo "Setup complete. Please restart iTerm2 to apply all changes."
