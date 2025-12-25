# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Repository Purpose

This is a **macOS-focused dotfiles repository** for backing up and managing shell configurations, Homebrew packages, iTerm2 settings, and WezTerm configuration. The Zsh configuration is OS-aware, so it can also be reused on Linux/Proxmox servers while keeping a single source of truth in Git.

## Key Files

- **`zsh/.zshrc`** - Zsh shell configuration using the Zap plugin manager, Starship prompt, OS-detection, and custom functions (loads `~/.zsh_aliases` for aliases)
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

The `.zshrc` file follows this high-level initialization order:
1. **Core env and OS detection** - PATH tweaks plus `IS_MAC` / `IS_LINUX` flags
2. **Prompt and Zap initialization** - Starship init and Zap plugin manager (`plug` definitions)
3. **Tool initialization** - `rbenv`, `zoxide`, `direnv`, `fzf`, `atuin`, `uv`, Docker helpers, etc.
4. **Aliases and OS-specific helpers** - `~/.zsh_aliases` for shared aliases, then Linux/Proxmox-only aliases/functions (e.g., `vms`, `cts`, `pvestat`)
5. **Host-local overrides** - optional `~/.zshrc.local` per host for unsynced tweaks (e.g., Proxmox-only environment, alternate Starship config)
6. **Syntax highlighting** - `fast-syntax-highlighting` is intentionally loaded last so it sees all aliases and functions

**Critical**: Tool configuration and aliases MUST come after Zap initialization so plugins and prompt are available, and syntax highlighting MUST remain at the end of the file.

### Key Zsh Components

- **Prompt**: Starship (Jetpack preset), configured via `~/.config/starship.toml` (with optional plain-text config for limited fonts)
- **Plugin manager**: Zap (`plug`-based plugin loading)
- **Essential plugins**: `zsh-autosuggestions`, `fast-syntax-highlighting` (loaded last for correct alias/function highlighting)
- **Modern tools**: `eza` (replaces `ls`), `zoxide` (`z` command for smart navigation), `fzf` (fuzzy finder and history search), `thefuck` (command corrections)
- **Host-local overrides**: `~/.zshrc.local` sourced at the end of `.zshrc` for per-host customizations (e.g., Proxmox-only `STARSHIP_CONFIG`)
- **History search**: FZF integration via `Ctrl+R` plus optional Atuin-backed history

### Homebrew Management

The `Brewfile` contains three types of installations:
- `tap` - Third-party Homebrew repositories
- `brew` - Command-line tools
- `cask` - GUI applications
- `vscode` - VS Code extensions

## Important Notes

### Tool Dependencies

Several tools are initialized in `.zshrc` when available (guarded with `command -v ...`):
- **rbenv** - Ruby version manager (`eval "$(rbenv init - zsh)"`)
- **zoxide** - Smart directory navigation (`eval "$(zoxide init zsh)"`) - creates `z` and `zi` commands
- **fzf** - Fuzzy finder integration (`source <(fzf --zsh)`) - enables Ctrl+R history search, Ctrl+T file search, Alt+C directory search
- **thefuck** - Command correction (`eval "$(thefuck --alias)"`) - creates `fuck` alias
- **Atuin** - Optional advanced history backend (`eval "$(atuin init zsh)"`)
- **Starship** - Prompt initializer (`eval "$(starship init zsh)"`)
- **iTerm2 shell integration** - Required for iTerm2 features on macOS only

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

#### Tmux for Data Engineers
Tmux provides session persistence and reproducible workspace layouts for long-running pipelines.

**Key Features:**
- 100,000 line scrollback for massive logs
- Auto-save/restore sessions every 15 minutes
- Fuzzy session switcher with `Ctrl-a + o`
- Integration with zoxide for smart directory jumping
- Vim-style navigation between panes

**Prefix key:** `Ctrl-a` (more ergonomic than default `Ctrl-b`)

**Essential keybindings:**
- `Ctrl-a + |` - Split pane horizontally
- `Ctrl-a + -` - Split pane vertically
- `Ctrl-a + h/j/k/l` - Navigate panes (Vim-style)
- `Ctrl-a + o` - Fuzzy search sessions (with sessionx)
- `Ctrl-a + r` - Reload configuration
- `Ctrl-a + I` - Install/update plugins

**Data Engineer Workspace Functions:**

1. **de-work** - Launch 3-pane development environment:
   ```bash
   de-work [session-name]
   # Left: Code editor
   # Right-top: btop (system monitor)
   # Right-bottom: Python REPL or logs
   ```

2. **pipeline-watch** - Monitor data pipeline with live logs:
   ```bash
   pipeline-watch /path/to/pipeline.log
   # Top-left: btop (resource usage)
   # Top-right: tail -f (live logs)
   # Bottom-right: Python REPL for testing
   ```

3. **homelab-ssh** - Quick SSH to homelab with dedicated tmux window:
   ```bash
   homelab-ssh [window-name]
   # Creates/reuses HomeLab session
   # Opens new window with SSH to 192.168.1.249
   ```

**Plugin highlights:**
- **tmux-sessionx** - Fuzzy session switcher (industry standard 2025)
- **tmux-resurrect** - Save/restore sessions
- **tmux-continuum** - Auto-save every 15 minutes
- **vim-tmux-navigator** - Seamless navigation between tmux/vim
- **catppuccin** - Modern, high-readability theme

**Installing plugins:**
```bash
# Start tmux
tmux

# Press: Ctrl-a + I (capital i)
# Wait for plugins to install
```
