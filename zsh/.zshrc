# ===== PATH Configuration (Load First) =====
export PATH="$HOME/.local/bin:$PATH"  # uv tools and local binaries

# Starship prompt (Jetpack preset)
# Configuration: ~/.config/starship.toml
eval "$(starship init zsh)"

# Initialize Zap (Zsh plugin manager)
if [[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ]]; then
  source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
else
  echo "Zap not found. Install it with:" >&2
  echo "  zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh)" >&2
fi

# Plugins managed by Zap
plug "zsh-users/zsh-autosuggestions"
plug "zdharma-continuum/fast-syntax-highlighting"

# thefuck integration (replaces Oh My Zsh thefuck plugin)
if command -v thefuck >/dev/null 2>&1; then
  eval "$(thefuck --alias)"
fi

# User configuration, aliases, and functions should go AFTER plugins.
# rbenv
eval "$(rbenv init - zsh)"

# zoxide (better cd) - smart directory navigation
eval "$(zoxide init zsh)"  # Initialize zoxide with 'z' and 'zi' commands

# direnv - automatic environment switching for projects
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# ===== Modern CLI Tool Aliases & Configurations =====

# eza (better ls) aliases
# Use ls for a detailed, pretty, directory-first listing with git integration
alias ls='eza -al --group-directories-first --icons --color=always --git'
# Common variants
alias ll='eza -al --group-directories-first --icons --git'
alias ld='eza -lD --icons'
alias lf='eza -lF --color=always --icons | grep -v /'
alias lh='eza -dl .* --group-directories-first --icons'
alias lt='eza -al --sort=modified --icons --git'

# bat (better cat) - syntax highlighting for files
# bat (better cat) - syntax highlighting for files
alias cat='bat --style=auto'  # Default: use bat instead of cat
alias bat='bat --style=auto'  # Explicit bat command
alias catp='bat --style=plain'  # Plain output (no decorations)
alias bathelp='bat --plain --language=help'
alias less='bat --style=plain --paging=always'  # Use bat for less
alias more='bat --style=plain --paging=always'  # Use bat for more
help() {
    "$@" --help 2>&1 | bathelp
}

# ripgrep (better grep) - faster searching
alias grep='rg'  # Default: use ripgrep instead of grep
alias egrep='rg'  # Extended grep
alias fgrep='rg -F'  # Fixed string grep
alias rgi='rg -i'  # Case insensitive
alias rgl='rg -l'  # Show only filenames

# fd (better find) - simpler and faster
alias find='fd'  # Default: use fd instead of find
alias fda='fd -H'  # Show hidden files
alias fdi='fd -i'  # Case insensitive

# dust (better du) - disk usage visualization
alias du='dust'  # Default: use dust instead of du
alias dud='dust -d 1'  # One level deep
alias duall='dust -d 0'  # All levels

# procs (better ps) - modern process viewer
alias ps='procs'  # Default: use procs instead of ps
alias pstree='procs --tree'  # Process tree view
alias pswatch='procs --watch'  # Watch processes

# btop (better top) - beautiful system monitor
alias top='btop'  # Default: use btop instead of top
alias htop='btop'  # Also replace htop

# fzf - fuzzy finder integration
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Use fd instead of find for fzf (respects .gitignore)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# fzf preview with bat
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# git-delta configuration for better git diffs
# Add to ~/.gitconfig manually or run:
# git config --global core.pager "delta"
# git config --global interactive.diffFilter "delta --color-only"
# git config --global delta.navigate true
# git config --global delta.light false
# git config --global merge.conflictstyle diff3
# git config --global diff.colorMoved default

# tlrc (tldr) - simplified man pages
alias man='tldr'  # Use tldr for quick help
alias manfull='command man'  # Use original man if needed

# erdtree (better tree) - modern file tree viewer
alias tree='erd'
alias treed='erd -L 2'  # 2 levels deep
alias treef='erd -f'  # files only
alias treeh='erd -H'  # show hidden files

# pv - pipe viewer for progress
# Usage: pv file.tar.gz | tar xzf -
# No aliases needed, use directly in pipes

# ===== Data Engineer Professional Tools =====

# atuin - SQLite-backed shell history with search by exit code
# Replaces Ctrl+R with powerful fuzzy search across all history
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh)"
  # atuin benefits:
  # - Search by exit code (find failed commands easily)
  # - Full-text search across unlimited history
  # - Optional encrypted sync across machines
  # Usage: Ctrl+R for fuzzy search, up/down arrows for inline history
fi

# uv - Modern Python package/project manager (2025 Data Engineer standard)
# Replaces pip, pipx, poetry, virtualenv with blazing-fast Rust implementation
if command -v uv >/dev/null 2>&1; then
  # Quick command execution (like npx/pipx)
  alias pyx='uvx'  # Example: pyx ruff check .
  
  # Project management aliases
  alias uv-sync='uv sync'  # Install/sync dependencies
  alias uv-add='uv add'    # Add a dependency
  alias uv-run='uv run'    # Run in project environment
  alias uv-venv='uv venv'  # Create virtual environment
  
  # Common Data Engineer workflows
  alias uv-jupyter='uvx jupyter lab'  # Launch Jupyter without global install
  alias uv-ipython='uvx ipython'      # Quick IPython shell
fi

# Docker shortcuts for Data Engineer workflows
if command -v docker >/dev/null 2>&1; then
  alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'  # Pretty process list
  alias dlog='docker logs -f'  # Follow logs (usage: dlog container-name)
  alias dexec='docker exec -it'  # Interactive exec (usage: dexec container-name bash)
  alias dstop='docker stop $(docker ps -q)'  # Stop all running containers
  alias dprune='docker system prune -af --volumes'  # Clean up everything (use with caution)
fi

# Python environment indicator (shows active venv in prompt)
# This works with uv, virtualenv, conda, etc.
export VIRTUAL_ENV_DISABLE_PROMPT=1  # Let starship handle it

# ===== Tmux Workspace Functions (Data Engineer) =====

# Launch a 3-pane Data Engineering workspace
# Usage: de-work [session-name]
de-work() {
  local session_name="${1:-DE}"
  
  if tmux has-session -t "$session_name" 2>/dev/null; then
    echo "Session '$session_name' already exists. Attaching..."
    tmux attach-session -t "$session_name"
    return
  fi
  
  tmux new-session -d -s "$session_name"
  tmux rename-window 'Dev'
  
  # Split into 3 panes: Code (main), Logs (right-top), Monitor (right-bottom)
  tmux split-window -h
  tmux split-window -v
  
  # Pane 1 (left): Main coding area
  tmux select-pane -t 1
  
  # Pane 2 (right-top): System monitor
  tmux select-pane -t 2
  tmux send-keys 'btop' C-m
  
  # Pane 3 (right-bottom): Python REPL or logs
  tmux select-pane -t 3
  tmux send-keys 'echo "Ready for logs or Python REPL"' C-m
  
  # Focus back on main pane
  tmux select-pane -t 1
  tmux attach-session -t "$session_name"
}

# Launch a pipeline monitoring workspace
# Usage: pipeline-watch <log-file-path>
pipeline-watch() {
  if [[ -z "$1" ]]; then
    echo "Usage: pipeline-watch <log-file-path>"
    return 1
  fi
  
  local log_file="$1"
  local session_name="monitor-$(basename "$log_file" .log)"
  
  if tmux has-session -t "$session_name" 2>/dev/null; then
    echo "Monitoring session already exists. Attaching..."
    tmux attach-session -t "$session_name"
    return
  fi
  
  tmux new-session -d -s "$session_name"
  tmux rename-window 'Pipeline'
  
  # Pane 1: Hardware monitor (top-left)
  tmux send-keys 'btop' C-m
  
  # Pane 2: Live logs (top-right)
  tmux split-window -h
  tmux send-keys "tail -f '$log_file'" C-m
  
  # Pane 3: Python REPL for testing (bottom-right)
  tmux split-window -v
  tmux send-keys 'python3' C-m
  
  # Focus on logs pane
  tmux select-pane -t 2
  tmux attach-session -t "$session_name"
}

# Quick homelab SSH with tmux session
# Usage: homelab-ssh [window-name]
homelab-ssh() {
  local window_name="${1:-homelab}"
  local session_name="HomeLab"
  
  if ! tmux has-session -t "$session_name" 2>/dev/null; then
    tmux new-session -d -s "$session_name"
  fi
  
  tmux new-window -t "$session_name" -n "$window_name"
  tmux send-keys -t "$session_name:$window_name" 'ssh admin@192.168.1.249' C-m
  
  if [[ -z "$TMUX" ]]; then
    tmux attach-session -t "$session_name"
  else
    tmux switch-client -t "$session_name"
  fi
}

# ===== Load Additional Aliases =====
# Source modern Data Engineer aliases from separate file
if [ -f ~/.zsh_aliases ]; then
    source ~/.zsh_aliases
fi

