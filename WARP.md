# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Repository Purpose

This is a **macOS dotfiles repository** for backing up and managing shell configurations, Homebrew packages, and iTerm2 settings. The goal is to enable complete restoration of a development environment on any new Mac.

## Key Files

- **`.zshrc`** - Zsh shell configuration with Oh My Zsh, Spaceship prompt, and custom functions
- **`Brewfile`** - Complete list of Homebrew packages (CLI tools, apps, VS Code extensions)
- **`install.sh`** - Setup script that creates symlinks and installs iTerm2 color scheme
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

# 4. Create symlinks and install iTerm2 settings
sh ~/.dotfiles/install.sh

# 5. Restart terminal
```

### Updating Configuration Backups

```bash
# Update Brewfile after installing/removing software
cd ~/.dotfiles
brew bundle dump --force
git add Brewfile
git commit -m "Update Brewfile"
git push

# Update shell configuration
cd ~/.dotfiles
git add .zshrc
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
zsh -c "source ~/.dotfiles/.zshrc"
```

## Architecture

### Dotfiles Management Strategy

This repository uses a **centralized dotfiles directory** (`~/.dotfiles`) with symlinks:
- Configuration files live in `~/.dotfiles/`
- `install.sh` creates symlinks from home directory to dotfiles directory
- Pattern: `ln -sfn ~/.dotfiles/.zshrc ~/.zshrc`

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

When modifying `install.sh`:
- Use `-sfn` flags: `-s` (symbolic), `-f` (force/overwrite), `-n` (no-dereference)
- Reference note: `.p10k.zsh` is in `install.sh` but not present in repo (legacy Powerlevel10k config)
