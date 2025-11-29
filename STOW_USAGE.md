# GNU Stow Quick Reference

This file provides quick reference for managing dotfiles with GNU Stow in this repository.

## Directory Structure

```
~/.dotfiles/
├── zsh/
│   └── .zshrc
├── tmux/
│   └── .tmux.conf
├── Brewfile
├── install.sh
├── README.md
└── ...
```

## Common Commands

All commands should be run from the home directory (`~`).

### Deploy Configurations (Stow)

```bash
cd ~
stow -d .dotfiles zsh tmux
```

Creates symlinks:
- `~/.zshrc` → `~/.dotfiles/zsh/.zshrc`
- `~/.tmux.conf` → `~/.dotfiles/tmux/.tmux.conf`

### Remove Configurations (Unstow)

```bash
cd ~
stow -D -d .dotfiles zsh tmux
```

Removes all symlinks created by stow.

### Update Configurations (Restow)

```bash
cd ~
stow -R -d .dotfiles zsh tmux
```

Removes and recreates symlinks. Useful after:
- Pulling changes from Git
- Restructuring the repository
- Adding new files to packages

### Dry Run (Simulation)

```bash
cd ~
stow -n -v -d .dotfiles zsh tmux
```

Shows what stow would do without actually doing it.
- `-n` = dry run
- `-v` = verbose output

### Stow Specific Packages

```bash
# Only stow zsh
cd ~
stow -d .dotfiles zsh

# Only stow tmux
cd ~
stow -d .dotfiles tmux
```

## Workflow Examples

### Setting Up New Machine

```bash
# 1. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Clone dotfiles
git clone git@github.com:drusho/zsh_backup.git ~/.dotfiles

# 3. Install all software
cd ~/.dotfiles
brew bundle install

# 4. Run install script (includes stow)
cd ~
sh ~/.dotfiles/install.sh

# 5. Install tmux plugins
tmux
# Press: Ctrl-a + I
```

### Making Changes on Mac Air

```bash
# Edit configs normally (they're symlinked)
vim ~/.zshrc
vim ~/.tmux.conf

# Commit changes
cd ~/.dotfiles
git add -A
git commit -m "Updated shell configuration"
git push origin main
```

### Syncing Changes to Mac Mini

```bash
# Pull latest changes
cd ~/.dotfiles
git pull origin main

# Restow to ensure symlinks are up to date
cd ~
stow -R -d .dotfiles zsh tmux

# Reload shell
source ~/.zshrc
```

### Adding New Package

```bash
cd ~/.dotfiles

# Create new package directory
mkdir -p newpackage

# Move config file into package
mv ~/.newconfig newpackage/.newconfig

# Stow the new package
cd ~
stow -d .dotfiles newpackage

# Commit to git
cd ~/.dotfiles
git add newpackage/
git commit -m "Add newpackage configuration"
git push
```

## Troubleshooting

### Stow Says "Existing Target"

**Problem**: Stow refuses to create symlink because a file already exists.

**Solution**:
```bash
# Back up the existing file
mv ~/.zshrc ~/.zshrc.backup

# Then stow
cd ~
stow -d .dotfiles zsh
```

### Symlinks Point to Wrong Location

**Problem**: Symlinks show full path instead of relative path.

**Solution**: This is normal! Because `~/.dotfiles` itself is a symlink to the Git repo, stow follows it and creates working symlinks.

### Configs Not Updating After Git Pull

**Problem**: Made changes on Mac Air, pulled on Mac Mini, but configs haven't changed.

**Solution**:
```bash
# Restow to refresh symlinks
cd ~
stow -R -d .dotfiles zsh tmux

# Reload shell
exec zsh
```

### Want to See What Files Are Stowed

```bash
# List symlinks in home directory
command ls -la ~ | grep ".dotfiles"

# Check specific file
readlink ~/.zshrc
readlink ~/.tmux.conf
```

## Stow Options Reference

| Option | Description |
|--------|-------------|
| `-d DIR` | Set stow directory (e.g., `-d ~/.dotfiles`) |
| `-t DIR` | Set target directory (default: parent of stow dir) |
| `-D` | Unstow (remove symlinks) |
| `-R` | Restow (unstow then stow) |
| `-n` | Dry run (don't actually do anything) |
| `-v` | Verbose (show what's being done) |
| `-S` | Stow (default action) |

## Resources

- [GNU Stow Official Manual](https://www.gnu.org/software/stow/manual/stow.html)
- [Managing Dotfiles with Stow](https://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html)
- This Repo's README: `~/.dotfiles/README.md`
