#!/bin/zsh

# This script sets up symlinks and installs iTerm2 preferences.
# It should be run from within the ~/.dotfiles directory.

echo "Creating symlinks for Zsh configuration files..."
ln -sfn ~/.dotfiles/.zshrc ~/.zshrc
ln -sfn ~/.dotfiles/.p10k.zsh ~/.p10k.zsh

echo "Installing iTerm2 color scheme..."
# This command tells macOS to open the .itermcolors file,
# which prompts iTerm2 to install it.
open ~/.dotfiles/Cobalt2.itermcolors

echo "Setup complete. Please restart iTerm2 to apply all changes."
