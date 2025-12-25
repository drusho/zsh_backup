# My macOS Development Environment (with Linux/Proxmox support)

This repository contains the complete configuration for my macOS development environment. It uses **GNU Stow** to manage dotfiles and settings for Zsh, tmux, iTerm2, Homebrew, and various modern command-line tools.

The primary goal is to be able to completely and automatically restore my preferred setup on any new Mac in minutes, while also reusing the same Zsh configuration on Linux/Proxmox servers via OS-aware logic.

## 🚀 Setting Up a New Mac

To set up a new computer with this configuration, follow these steps in order.

### 1. Install Homebrew

Homebrew is the package manager for macOS. Open the terminal and run the following command:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Clone This Repository

Clone this dotfiles repository into a hidden directory in your home folder.

```bash
git clone git@github.com:drusho/zsh_backup.git ~/.dotfiles
```

### 3. Install All Software

Navigate into the new directory and use the included `Brewfile` to install all the command-line tools and graphical applications.

```bash
cd ~/.dotfiles
brew bundle install
```

### 4. Run the Installation Script

The `install.sh` script uses GNU Stow to create symlinks for your configuration files and installs the iTerm2 color scheme.

```bash
cd ~
sh ~/.dotfiles/install.sh
```

**What this does:**
- Installs GNU Stow (if not present)
- Creates symlinks using: `stow -d ~/.dotfiles zsh tmux`
- Installs TPM (Tmux Plugin Manager)
- Opens iTerm2 color scheme

### 5. Install tmux Plugins

After starting tmux for the first time:
```bash
tmux
# Press: Ctrl-a + I (capital i) to install plugins
```

### 6. Restart Your Terminal

Completely quit and restart iTerm2 for all changes to take effect. Your new professional environment is now ready!

## 🖥 Using This Repo on Linux/Proxmox

The Zsh configuration is OS-aware and works on Linux/Proxmox terminals in addition to macOS:

1. Install dependencies (Debian/Proxmox example):
   ```bash
   sudo apt update
   sudo apt install -y git zsh stow fzf zoxide eza bat ripgrep fd-find dust btop
   ```
2. Clone the repo (same layout as macOS):
   ```bash
   git clone git@github.com:drusho/zsh_backup.git ~/.dotfiles
   cd ~/.dotfiles
   stow zsh tmux
   ```
3. Set Zsh as the default shell and re-login:
   ```bash
   chsh -s "$(command -v zsh)"
   ```

On Linux/Proxmox hosts:
- `.zshrc` auto-detects Linux (`IS_LINUX=true`) and enables Proxmox/homelab aliases like `vms`, `cts`, `pvestat`, `pve-logs`, `storage`, `update`, and `cleanup`.
- The `pvestat` helper is a smart function: on clustered nodes it runs `pvecm status`, on standalone nodes it falls back to `pveversion -v` to avoid noisy corosync errors.
- Modern Unix overrides (e.g., `ls`, `cat`) are defined in `~/.zsh_aliases`, with Linux-specific tweaks such as using `batcat` when `bat` is not available.
- Per-host overrides live in `~/.zshrc.local` (not tracked in Git) and are sourced at the end of `.zshrc`, ideal for Proxmox-only settings like a plain-text Starship config.
- If noVNC or server terminals don’t render Nerd Font icons correctly, you can point `STARSHIP_CONFIG` at a plain-text Starship config (e.g., `~/.config/starship-plain.toml`).

## 💾 Syncing Between Machines

### How Stow Works

This repo uses GNU Stow to manage symlinks:
- Your actual config files live in `~/.dotfiles/zsh/.zshrc` and `~/.dotfiles/tmux/.tmux.conf`
- Stow creates symlinks: `~/.zshrc` → `~/.dotfiles/zsh/.zshrc`
- When you edit `~/.zshrc`, you're actually editing the file in the repo
- Changes automatically sync via Git!

### Making Changes on One Machine

```bash
# Edit configs normally (they're symlinked to the repo)
vim ~/.zshrc
vim ~/.tmux.conf

# Navigate to dotfiles and commit
cd ~/.dotfiles
git add -A
git commit -m "Updated configs"
git push
```

### Syncing to Another Machine

```bash
# Pull latest changes
cd ~/.dotfiles
git pull

# Restow to update symlinks (if structure changed)
cd ~
stow -R -d .dotfiles zsh tmux
```

### Updating Installed Software

After installing/uninstalling software:

```bash
cd ~/.dotfiles
brew bundle dump --force
git add Brewfile
git commit -m "Update Brewfile"
git push
```

## 📦 What's Included?

This setup includes:

### Shell Configuration
- **Zsh** (`.zshrc` + `.zsh_aliases`): OS-aware Zap-based configuration with Starship prompt and modern plugins
  - Prompt: **Starship** (Jetpack preset) with Nerd Font icons
  - OS detection: sets `IS_MAC` / `IS_LINUX` flags so the same config works on macOS and Linux/Proxmox
  - Aliases: central "single source of truth" in `~/.zsh_aliases` (modern Unix overrides, data-engineering helpers)
  - Host-local overrides: optional `~/.zshrc.local` per machine, sourced near the end of `.zshrc` for tweaks that should not be synced via Git (e.g., Proxmox-only env vars or Starship config).
  - Plugins via Zap: `zsh-autosuggestions`, `fast-syntax-highlighting` (loaded last for correct highlighting)
  - Extra tooling: `zoxide` (smart cd with `z`/`zi`), `thefuck` (command corrections), `fzf` (fuzzy search and history)

### Terminal Multiplexer
- **tmux** (`.tmux.conf`): Full mouse support, Catppuccin Mocha theme
  - Prefix: `Ctrl-a` (easier than `Ctrl-b`)
  - 10+ plugins via TPM (resurrect, continuum, sidebar, etc.)
  - Vim-style navigation, Nerd Font icons

### Modern CLI Tools (replacing legacy commands)
- **bat** → replaces `cat` (syntax highlighting)
- **eza** → replaces `ls` (colors, icons, git integration)
- **ripgrep** → replaces `grep` (faster searching)
- **fd** → replaces `find` (simpler syntax)
- **dust** → replaces `du` (visual disk usage)
- **procs** → replaces `ps` (modern process viewer)
- **btop** → replaces `top` (beautiful system monitor)
- **git-delta** → enhanced git diffs
- **fzf** → fuzzy finder and history search (Ctrl-T, Ctrl-R, Alt-C)
- **tlrc** → simplified man pages
- **erdtree** → modern tree viewer
- **zoxide** → smart directory navigation (`z` command)

### Visual Customization
- **iTerm2 Color Scheme**: Cobalt2 preset
- **Catppuccin Theme**: For tmux status bar
- **Nerd Fonts**: Icons in terminal

### Package Management
- **Homebrew** (`Brewfile`): All CLI tools, apps, and VS Code extensions
- **GNU Stow**: Dotfile symlink management
- **TPM**: Tmux plugin manager

### Documentation
- **WARP.md**: Configuration guide for AI assistants
- **CHANGELOG.md**: Complete history of changes
- **README.md**: This file - setup and usage instructions
- **STOW_USAGE.md**: GNU Stow reference guide

## 🎯 Quick Start: Using Your New Tools

After setup, here's how to use the modern CLI tools that replace traditional commands:

### Smart Navigation
```bash
# zoxide - Smart directory jumping (learns from your habits)
z Documents          # Jump to ~/Documents
z down               # Jump to ~/Downloads (fuzzy match)
zi                   # Interactive directory picker

# Note: cd still works normally, but z learns and gets smarter over time
```

### Enhanced Listing & Viewing
```bash
# eza - Modern ls with icons and git integration
ls                   # Auto-aliased to eza with icons, colors, git status
ll                   # Detailed listing
lt                   # Sort by modification time
ld                   # List directories only
lh                   # List hidden files

# bat - cat with syntax highlighting
cat file.js          # Auto-aliased to bat (syntax highlighting)
catp file.js         # Plain output (no decorations)
bat file.py          # Explicit bat command
```

### Powerful Search
```bash
# fzf - Fuzzy finder (already integrated)
Ctrl+R               # Search command history (fuzzy)
Ctrl+T               # Search files (with preview)
Alt+C                # Search directories (cd into selection)

# ripgrep - Fast code search
grep "function"       # Auto-aliased to ripgrep (respects .gitignore)
rg -i "TODO"         # Case-insensitive search
rgl "error"          # Show only filenames

# fd - Simple find alternative
find "*.js"          # Auto-aliased to fd
fd -e py             # Find all Python files
fda "config"         # Include hidden files
```

### System Monitoring
```bash
# btop - Beautiful system monitor
top                  # Auto-aliased to btop
htop                 # Also aliased to btop

# procs - Modern process viewer
ps                   # Auto-aliased to procs
ps grep chrome       # Search processes
pstree               # Show process tree

# dust - Visual disk usage
du                   # Auto-aliased to dust
dud                  # One level deep
duall                # All levels
```

### File Trees & Help
```bash
# erdtree - Modern tree viewer
tree                 # Auto-aliased to erdtree
treed                # 2 levels deep
treeh                # Include hidden files

# tlrc - Quick command reference
man tar              # Auto-aliased to tldr (simplified)
manfull tar          # Use traditional man page
```

### Command Corrections
```bash
# thefuck - Fix command typos
gti status           # Typo!
fuck                 # Runs: git status (auto-corrects)
```

### Zsh Plugins (Auto-Active)
- **zsh-autosuggestions**: Type a command, see gray suggestions from history (press → to accept)
- **fast-syntax-highlighting**: Commands turn green (valid) or red (invalid) as you type
- **spaceship-prompt**: Shows git branch, status, and more in your prompt

### Tmux Quick Reference
```bash
# Start tmux
tmux

# Prefix key: Ctrl-a (not Ctrl-b)
Ctrl-a + c           # Create new window
Ctrl-a + "           # Split pane horizontally
Ctrl-a + %           # Split pane vertically
Ctrl-a + arrow       # Navigate panes
Ctrl-a + d           # Detach session
tmux attach          # Re-attach to session
```

### Nerd Fonts Setup
For icons to display correctly in your terminal:

1. **Already installed**: `font-jetbrains-mono-nerd-font`, `font-fira-code-nerd-font`
2. **iTerm2**: Preferences → Profiles → Text → Font → Select "JetBrainsMono Nerd Font Mono"
3. **Warp**: Settings → Appearance → Text → Font Family → Select "FiraCode Nerd Font" (if available)
4. **Terminal.app**: Preferences → Profiles → Font → Select a Nerd Font

---

## 🔧 Troubleshooting

### Icons show as question marks
- Install a Nerd Font: `brew install --cask font-jetbrains-mono-nerd-font`
- Configure your terminal to use it (see Nerd Fonts Setup above)

### Command not found: z
- Run: `source ~/.zshrc`
- Verify zoxide is installed: `which zoxide`

### Symlinks not working
- Remove existing file: `rm ~/.zshrc`
- Re-run stow: `stow -d ~/.dotfiles -t ~ zsh`
- Verify: `ls -la ~/.zshrc` (should show `->`)

### FZF history search not working
- Verify fzf is installed: `which fzf`
- Reload config: `source ~/.zshrc`
- Test: Press `Ctrl+R` in terminal
