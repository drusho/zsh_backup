# My macOS Development Environment

This repository contains the complete configuration for my macOS development environment. It uses **GNU Stow** to manage dotfiles and settings for Zsh, tmux, iTerm2, Homebrew, and various modern command-line tools.

The primary goal is to be able to completely and automatically restore my preferred setup on any new Mac in minutes.

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
- **Zsh** (`.zshrc`): Zap plugin manager with Spaceship prompt and modern plugins
  - Managed via Zap: `spaceship-prompt`, `zsh-autosuggestions`, `fast-syntax-highlighting`, `zsh_codex`
  - Extra tooling: `zoxide` (smart cd), `thefuck` (command corrections)

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
- **fzf** → fuzzy finder (Ctrl-T, Ctrl-R, Alt-C)
- **tlrc** → simplified man pages
- **erdtree** → modern tree viewer
- **hstr** → better command history (Ctrl-R)
- **zoxide** → smart directory jumper

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
