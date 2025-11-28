# Changelog

All notable changes to this dotfiles repository.

## [2025-11-28] - Mac Air Configuration Sync & Modern CLI Tools

### Added

#### Documentation
- **WARP.md** - Configuration guide for Warp AI assistant with:
  - Repository purpose and architecture
  - Common commands for setup and maintenance
  - Dotfiles management strategy
  - Zsh configuration structure and initialization order
  - Key components (Spaceship theme, plugins, modern tools)
  - Bitwarden integration notes
  - Tool dependencies and symlink management

#### Modern CLI Tools - First Wave
- **bat** (0.26.0) - Better `cat` with syntax highlighting
  - Aliased `cat` to `bat --style=auto`
  - Added `catp` for plain output
  - Added `help()` function for colorized help pages
- **fzf** (0.67.0) - Fuzzy finder for files and commands
  - Integrated with `fd` and `bat` for previews
  - Ctrl+T: Fuzzy file search with live preview
  - Ctrl+R: Fuzzy command history search
  - Alt+C: Fuzzy directory navigation
- **ripgrep** (15.1.0) - Faster `grep` replacement
  - Aliased `grep` to `rg`
  - Added `rgi` (case insensitive) and `rgl` (filenames only)
- **fd** (10.3.0) - Better `find` with simpler syntax
  - Aliased `find` to `fd`
  - Integrated with fzf for file discovery
- **dust** (1.2.3) - Better `du` with visual disk usage
  - Aliased `du` to `dust`
- **procs** (0.14.10) - Modern process viewer
  - Aliased `ps` to `procs`
- **btop** (1.4.5) - Beautiful system monitor
  - Aliased `top` to `btop`
- **git-delta** (0.18.2) - Enhanced git diffs with syntax highlighting
  - Configured as default git pager
  - Enabled for all git diff operations
  - Set up navigation, color themes, and merge conflict styles

#### Modern CLI Tools - Second Wave
- **tlrc** (1.12.0) - Simplified man pages with examples
  - Replaced deprecated `tldr` with maintained `tlrc`
  - Aliased `man` to `tldr` for quick help
  - Added `manfull` for original man pages
- **erdtree** (3.1.2) - Modern file tree viewer with colors
  - Aliased `tree` to `erd`
  - Added shortcuts: `treed` (2 levels), `treef` (files only), `treeh` (hidden files)
- **hstr** (3.1) - Enhanced command history search
  - Bound to Ctrl+R for interactive history
  - Configured with hicolor theme
  - Added `hh` alias for direct access
  - Set to skip commands with leading space from history
- **fish** (4.2.1) - Friendly interactive shell
  - Available as alternative shell (not default)
- **pv** (1.10.2) - Pipe viewer for monitoring data progress
  - Use in pipes: `pv file.tar.gz | tar xzf -`

#### Enhanced Tools
- **zoxide** - Smart directory navigation
  - Aliased `cd` to `z` for intelligent directory jumping
  - Learns most-used directories over time
  - Supports partial name matching (e.g., `cd doc` → `~/Documents`)

#### Homebrew Packages (New)
- node
- tesseract
- libyaml
- readline
- GitHub Desktop (cask)
- Warp terminal (cask)
- Various tool dependencies (jpeg-turbo, libzip)

### Changed

#### Configuration
- **.zshrc** structure reorganized:
  - Added "Modern CLI Tool Aliases & Configurations" section
  - Simplified plugin order (moved `fast-syntax-highlighting` to top)
  - Removed Bitwarden functions (Mac Mini specific, not needed on Mac Air)
  - Enhanced `eza` aliases with new variations:
    - `ld` - List directories only
    - `lf` - List files only (no directories)
    - `lh` - List hidden files with group-directories-first
    - `ll` - All files with group-directories-first
    - `ls` - All files sorted by size (no directories)
    - `lt` - All files sorted by modification time

#### Dotfiles Management
- Fixed symlink structure:
  - `~/.dotfiles` now symlinks to `~/Documents/GitHub/repositories/zsh_backup`
  - `~/.zshrc` symlinks to `~/.dotfiles/.zshrc`
  - All changes automatically tracked in Git repo
  - Proper sync between local edits and GitHub

### Removed
- Deprecated `tldr` (replaced with `tlrc`)
- Bitwarden CLI functions from Mac Air's `.zshrc`:
  - `bwu()` - Vault unlock function
  - `getpw()` - Password retrieval function
  - `sshnas()` - NAS SSH function

### Git Configuration
- Set git-delta as default pager globally
- Enabled delta for interactive diffs
- Configured delta navigation and themes
- Set diff3 conflict style for better merge conflict resolution
- Enabled colored moved code detection

### Technical Details

#### Installation Order
1. Initial Mac Air sync (replaced Mac Mini's config)
2. Modern CLI tools installation (bat, fzf, ripgrep, fd, dust, procs, btop, git-delta)
3. Additional tools (tlrc, erdtree, hstr, fish, pv)
4. Zoxide cd alias configuration
5. Dotfiles symlink structure setup

#### File Changes Summary
- `.zshrc`: +79 lines (modern tool configurations and aliases)
- `Brewfile`: +23 packages (8 CLI tools + 15 dependencies/casks)
- `WARP.md`: +123 lines (new file)
- `CHANGELOG.md`: +169 lines (this file)

### Notes

#### Known Issues
- `dstat` not available on macOS (Linux-only tool)
- Git credential warning: `'credential-wincred' is not a git command` (can be ignored)

#### For Mac Mini Sync
To sync these changes to Mac Mini:
```bash
cd ~/.dotfiles
git pull origin main
brew bundle install
source ~/.zshrc
```

#### Verification
All configurations tested and verified working on Mac Air M1 running macOS Sequoia.

---

**Total Commits Today**: 5  
**Files Modified**: 3 (.zshrc, Brewfile, WARP.md)  
**New Files**: 2 (WARP.md, CHANGELOG.md)  
**CLI Tools Added**: 16  
**Lines of Configuration Added**: ~100
