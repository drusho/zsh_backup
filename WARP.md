# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Repository Purpose

This is a **macOS dotfiles repository** for backing up and managing shell configurations, Homebrew packages, iTerm2 settings, and WezTerm configuration. The goal is to enable complete restoration of a development environment on any new Mac.

## Key Files

- **`zsh/.zshrc`** - Zsh shell configuration using the Zap plugin manager, Spaceship prompt, and custom functions
- **`tmux/.tmux.conf`** - Tmux configuration with Catppuccin theme and plugins
- **`wezterm/.wezterm.lua`** - WezTerm terminal emulator configuration with Cobalt2-inspired theme
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
vim ~/.zshrc  # or vim ~/.tmux.conf or vim ~/.wezterm.lua
cd ~/.dotfiles
git add zsh/.zshrc  # or tmux/.tmux.conf or wezterm/.wezterm.lua
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
- Configuration files organized in subdirectories: `zsh/.zshrc`, `tmux/.tmux.conf`, `wezterm/.wezterm.lua`
- `install.sh` uses Stow to create symlinks: `stow -d ~/.dotfiles zsh tmux wezterm`
- Stow creates symlinks: `~/.zshrc` → `~/.dotfiles/zsh/.zshrc`, `~/.wezterm.lua` → `~/.dotfiles/wezterm/.wezterm.lua`
- When you edit `~/.zshrc` or `~/.wezterm.lua`, you're actually editing the file in the repo
- Changes automatically sync via Git!

### Zsh Configuration Structure

The `.zshrc` file follows this initialization order:
1. **Prompt and Zap initialization** - Spaceship prompt settings and Zap plugin definitions
2. **User configuration** - Custom aliases, functions, and tool initialization (modern CLI tools, history, etc.)

**Critical**: User configuration MUST come AFTER Zap initialization so plugins and prompt are available.

### Key Zsh Components

- **Theme**: Spaceship prompt (async, minimal sections for performance)
- **Plugin manager**: Zap (`plug`-based plugin loading)
- **Essential plugins**: `spaceship-prompt`, `zsh-autosuggestions`, `fast-syntax-highlighting`
- **Modern tools**: `eza` (replaces `ls`), `zoxide` (`z` command for smart navigation), `fzf` (fuzzy finder and history search), `thefuck` (command corrections)
- **History search**: FZF integration via `Ctrl+R` (industry standard, replaces hstr)

### Homebrew Management

The `Brewfile` contains three types of installations:
- `tap` - Third-party Homebrew repositories
- `brew` - Command-line tools
- `cask` - GUI applications
- `vscode` - VS Code extensions

## Important Notes

### Tool Dependencies

Several tools must be initialized in `.zshrc`:
- **rbenv** - Ruby version manager (`eval "$(rbenv init - zsh)"`)
- **zoxide** - Smart directory navigation (`eval "$(zoxide init zsh)"`) - creates `z` and `zi` commands
- **fzf** - Fuzzy finder integration (`source <(fzf --zsh)`) - enables Ctrl+R history search, Ctrl+T file search, Alt+C directory search
- **thefuck** - Command correction (`eval "$(thefuck --alias)"`) - creates `fuck` alias
- **iTerm2 shell integration** - Required for iTerm2 features

### Symlink Management

This repository uses GNU Stow for symlink management:
- Symlinks are created with: `stow -d ~/.dotfiles zsh tmux wezterm`
- To remove symlinks: `stow -D -d ~/.dotfiles zsh tmux wezterm`
- To update symlinks after Git pull: `stow -R -d ~/.dotfiles zsh tmux wezterm`
- See `STOW_USAGE.md` for comprehensive Stow documentation

### WezTerm Configuration

WezTerm is a modern, GPU-accelerated terminal emulator with the following features:
- **Custom Cobalt2-inspired color scheme** - Matches iTerm2 Cobalt2 theme
- **Minimal professional tab bar** - Clean styling, hidden when only one tab
- **High performance** - WebGPU rendering at 120 FPS
- **Built-in pane splitting** - No need for tmux for basic splitting
- **macOS integration** - Copy-on-select, right-click paste

**Key bindings:**
- `CMD+T` - New tab
- `CMD+W` - Close pane/tab (with confirmation)
- `CMD+[` / `CMD+]` - Previous/next tab
- `CMD+1-9` - Jump to specific tab
- `CMD+SHIFT+|` - Split horizontally
- `CMD+SHIFT+_` - Split vertically
- `CMD+Arrow` - Navigate between panes
- `CMD+K` - Clear scrollback

**Configuration location:** `~/.wezterm.lua` (symlinked to `~/.dotfiles/wezterm/.wezterm.lua`)

### Data Engineer Professional Features

#### Workspace Management
WezTerm workspaces let you organize terminal sessions by project/context:
- `CMD+SHIFT+W` - Switch between workspaces (HomeLab, Work, AI-Server, etc.)
- `CMD+SHIFT+N` - Create new named workspace
- Each workspace maintains its own tabs and panes
- Seamlessly switch between local Python dev and remote server work

#### SSH Integration
Built-in SSH domains for quick homelab access:
- `CMD+SHIFT+S` - Quick SSH launcher (fuzzy search)
- Pre-configured: `homelab-nas` (192.168.1.249)
- Command line: `wezterm connect homelab-nas`
- SSH sessions survive network reconnections

#### Atuin Shell History
SQLite-backed shell history with advanced search:
- `Ctrl+R` - Fuzzy search across unlimited history
- **Search by exit code** - Find failed commands from days ago
- Full-text search with context
- Optional encrypted sync across Mac and Linux servers
- Critical for Data Engineers running complex multi-line commands

**Installation:**
```bash
brew install atuin
atuin import auto  # Import existing history
atuin register     # Optional: enable sync
```

#### Modern Python Tooling (uv)
`uv` is the 2025 Data Engineer standard for Python (replaces pip/pipx/poetry):
- `pyx <command>` - Run any Python tool without installing (`uvx`)
- `uv-jupyter` - Launch Jupyter Lab instantly
- `uv-ipython` - Quick IPython shell
- `uv-sync` - Sync project dependencies
- `uv-venv` - Create virtual environments

**Why uv:**
- 10-100x faster than pip
- Production parity (same tool for dev and deployment)
- Rust-based, handles complex dependency resolution
- Compatible with pip/pyproject.toml

**Installation:**
```bash
brew install uv
cd your-python-project
uv init  # Create new project
uv add pandas polars jupyter  # Add dependencies
uv run python script.py  # Run in isolated environment
```
