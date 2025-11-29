# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Repository Purpose

This is a **macOS dotfiles repository** for backing up and managing shell configurations, Homebrew packages, and iTerm2 settings. The goal is to enable complete restoration of a development environment on any new Mac.

## Key Files

- **`zsh/.zshrc`** - Zsh shell configuration with Oh My Zsh, Spaceship prompt, and custom functions
- **`tmux/.tmux.conf`** - Tmux configuration with Catppuccin theme and plugins
- **`Brewfile`** - Complete list of Homebrew packages (CLI tools, apps, VS Code extensions)
- **`install.sh`** - Setup script that uses GNU Stow to create symlinks and installs iTerm2 color scheme
- **`Cobalt2.itermcolors`** - iTerm2 color scheme preset

## Common Commands

### Setting Up a New Mac

```bash
# 1. Install Homebrew first
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Clone this repo
git clone git@github.com:drusho/zsh_backup.git ~/.dotfiles

# 3. Install all software from Brewfile
cd ~/.dotfiles
brew bundle install

# 4. Run installation script (uses GNU Stow for symlinks)
cd ~
sh ~/.dotfiles/install.sh

# 5. Install tmux plugins (if using tmux)
tmux
# Press: Ctrl-a + I (capital i) to install plugins

# 6. Restart terminal
```

### Updating Configuration Backups

```bash
# Update Brewfile after installing/removing software
cd ~/.dotfiles
brew bundle dump --force
git add Brewfile
git commit -m "Update Brewfile"
git push

# Update shell configuration (files are symlinked via Stow)
vim ~/.zshrc  # or vim ~/.tmux.conf
cd ~/.dotfiles
git add zsh/.zshrc  # or tmux/.tmux.conf
git commit -m "Update Zsh configuration"
git push
```

### Testing Changes

```bash
# Test Brewfile syntax
brew bundle check

# Validate shell script syntax
zsh -n install.sh

# Test .zshrc without affecting current session
zsh -c "source ~/.zshrc"
```

## Architecture

### Dotfiles Management Strategy

This repository uses **GNU Stow** for dotfile management with a centralized directory:
- Repository location: `~/Documents/GitHub/zsh_backup` (aliased as `~/.dotfiles`)
- Configuration files organized in subdirectories: `zsh/.zshrc`, `tmux/.tmux.conf`
- `install.sh` uses Stow to create symlinks: `stow -d ~/.dotfiles zsh tmux`
- Stow creates symlinks: `~/.zshrc` → `~/.dotfiles/zsh/.zshrc`
- When you edit `~/.zshrc`, you're actually editing the file in the repo
- Changes automatically sync via Git!

### Zsh Configuration Structure

The `.zshrc` file follows this initialization order:
1. **Oh My Zsh setup** - Theme and plugin definitions (lines 1-38)
2. **Source Oh My Zsh** - `source $ZSH/oh-my-zsh.sh` (line 42) - MUST come after theme/plugins
3. **User configuration** - Custom aliases, functions, tool initialization (lines 44+)

**Critical**: User configuration MUST come AFTER sourcing Oh My Zsh to avoid being overwritten.

### Key Zsh Components

- **Theme**: Spaceship prompt (async, minimal sections for performance)
- **Essential plugins**: `git`, `zsh-autosuggestions`, `fast-syntax-highlighting`, `zsh_codex`
- **Modern tools**: `eza` (replaces `ls`), `zoxide` (replaces `cd`), `thefuck` (command corrections)
- **Custom functions**:
  - `bwu()` - Unlocks Bitwarden vault and exports session key
  - `getpw()` - Retrieves passwords from Bitwarden
  - `sshnas()` - SSH to NAS using Bitwarden-stored credentials with sshpass

### Homebrew Management

The `Brewfile` contains three types of installations:
- `tap` - Third-party Homebrew repositories
- `brew` - Command-line tools
- `cask` - GUI applications
- `vscode` - VS Code extensions

## Important Notes

### Bitwarden Integration

The `.zshrc` contains Bitwarden CLI integration for secure credential management:
- Must run `bwu()` first to unlock vault and export `$BW_SESSION`
- `sshnas()` function uses sshpass with Bitwarden to SSH without manually entering passwords
- Bitwarden item IDs are hardcoded in functions (see line 78 for NAS credentials)

### Tool Dependencies

Several tools must be initialized in `.zshrc`:
- **rbenv** - Ruby version manager (`eval "$(rbenv init - zsh)"`)
- **zoxide** - Smart directory navigation (`eval "$(zoxide init zsh)"`)
- **iTerm2 shell integration** - Required for iTerm2 features (line 86)

### Symlink Management

This repository uses GNU Stow for symlink management:
- Symlinks are created with: `stow -d ~/.dotfiles zsh tmux`
- To remove symlinks: `stow -D -d ~/.dotfiles zsh tmux`
- To update symlinks after Git pull: `stow -R -d ~/.dotfiles zsh tmux`
- See `STOW_USAGE.md` for comprehensive Stow documentation
