#!/bin/zsh

# This script sets up dotfiles and Data Engineer tooling.
# Run from anywhere - it will handle paths automatically.

DOTFILES_DIR="$HOME/.dotfiles"

echo "=== Data Engineer Dotfiles Setup ==="
echo ""

# 1. Install Homebrew dependencies
echo "📦 Installing Homebrew packages..."
if [ -f "$DOTFILES_DIR/Brewfile" ]; then
    brew bundle --file="$DOTFILES_DIR/Brewfile"
    echo "✅ Homebrew packages installed"
else
    echo "⚠️  Brewfile not found at $DOTFILES_DIR/Brewfile"
fi
echo ""

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
echo ""

# 2. Install tmux plugin manager (TPM)
echo "🔧 Installing tmux plugin manager (TPM)..."
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo "✅ TPM installed. Run 'Ctrl-a + I' in tmux to install plugins."
else
    echo "✅ TPM already installed."
fi
echo ""

# 3. Configure atuin (shell history sync)
echo "📜 Configuring atuin (shell history)..."
if command -v atuin &> /dev/null; then
    if [ ! -f "$HOME/.local/share/atuin/config.toml" ]; then
        echo "Run 'atuin register' to enable history sync across machines (optional)"
        echo "Or run 'atuin import auto' to import existing shell history"
    else
        echo "✅ Atuin already configured"
    fi
else
    echo "⚠️  Atuin not found. Install with: brew install atuin"
fi
echo ""

# 4. Install Python tools via uv (isolated, not global pip)
echo "🐍 Installing Python Data Engineer tools via uv..."
if command -v uv &> /dev/null; then
    echo "Installing: sqlfluff (SQL linter)"
    uv tool install sqlfluff 2>/dev/null || echo "sqlfluff already installed"
    
    echo "Note: Install other tools as needed with 'uv tool install <package>'"
    echo "  - dbt-core (data transformation)"
    echo "  - ruff (Python linter/formatter)"
    echo "  - ipython (enhanced Python REPL)"
    echo "✅ Python tools setup complete"
else
    echo "⚠️  uv not found. Install with: brew install uv"
fi
echo ""

echo "=========================================="
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal (or run: source ~/.zshrc)"
echo "  2. Start tmux and press 'Ctrl-a + I' to install plugins"
echo "  3. Run 'atuin import auto' to import shell history"
echo "  4. Test workspace commands: de-work, pipeline-watch, homelab-ssh"
echo "=========================================="
