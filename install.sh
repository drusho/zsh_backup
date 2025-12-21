#!/bin/zsh

# This script sets up symlinks using GNU Stow and installs iTerm2 preferences.
# It should be run from the home directory.

echo "Using GNU Stow to create symlinks..."

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    echo "GNU Stow is not installed. Installing via Homebrew..."
    brew install stow
fi

# Navigate to home directory and use stow
cd ~
stow -d .dotfiles zsh tmux wezterm

# Create .config directory if it doesn't exist
mkdir -p ~/.config

# Symlink starship config
if [ -f ~/.config/starship.toml ]; then
    echo "Backing up existing starship config..."
    mv ~/.config/starship.toml ~/.config/starship.toml.backup
fi
ln -s ~/.dotfiles/starship/starship.toml ~/.config/starship.toml

echo "✅ Symlinks created for zsh, tmux, wezterm, and starship configurations"

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
