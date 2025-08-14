# My macOS Development Environment

This repository contains the complete configuration for my macOS development environment. It uses a "dotfiles" approach to back up and manage settings for Zsh, iTerm2, Homebrew, and various command-line tools.

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

The `install.sh` script will create the necessary symbolic links for your configuration files and install the iTerm2 color scheme.

```bash
sh ~/.dotfiles/install.sh
```

### 5. Restart Your Terminal

Completely quit and restart iTerm2 for all changes to take effect. Your new professional environment is now ready!

## 💾 Updating the Backup

To keep this repository in sync with your current setup, you need to commit any changes you make.

### Updating Installed Software

After you install or uninstall any software with Homebrew, you should regenerate your `Brewfile`.

```bash
# Navigate to your dotfiles directory
cd ~/.dotfiles

# Overwrite the old Brewfile with the current list of installed packages
brew bundle dump --force

# Commit and push the changes
git add Brewfile
git commit -m "Update Brewfile"
git push
```

### Updating Configuration Files

If you edit your `.zshrc`, iTerm2 settings, or any other file in the `~/.dotfiles` directory, simply commit and push the changes.

```bash
# Navigate to your dotfiles directory
cd ~/.dotfiles

# Add the changed file (e.g., .zshrc)
git add .zshrc

# Commit and push the update
git commit -m "Update Zsh configuration"
git push
```

## 📦 What's Included?

This setup includes:

- **Zsh Configuration (`.zshrc`)**: A powerful shell setup managed with Oh My Zsh, including a curated list of plugins (`zsh-autosuggestions`, `zoxide`, `zsh_codex`, etc.).
    
- **iTerm2 Settings**: A `com.googlecode.iterm2.plist` file that stores all iTerm2 preferences, including window arrangements and profiles.
    
- **iTerm2 Color Scheme**: The `Cobalt2` color preset.
    
- **Homebrew Packages (`Brewfile`)**: A complete list of all installed command-line tools and applications for easy restoration.
    
- **Shell Tools and Aliases**: Modern tools like `eza` (a better `ls`) and helpful aliases and functions for common tasks like connecting to the NAS.
    
- **Installation Script (`install.sh`)**: An automated script to set up a new machine quickly.