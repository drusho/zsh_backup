# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="spaceship"
# Spaceship settings
SPACESHIP_PROMPT_ASYNC=true
SPACESHIP_PROMPT_ADD_NEWLINE=true
SPACESHIP_CHAR_SYMBOL="⚡"
# Minimal spaceship sections for performance
SPACESHIP_PROMPT_ORDER=(
  time
  user
  dir
  git
  line_sep
  char
)

plugins=(
  fast-syntax-highlighting
  zsh_codex
  npm
  node
  z
  thefuck
  virtualenv
  web-search
  zsh-autosuggestions
)
# This line loads Oh My Zsh and is ESSENTIAL.
# It must come AFTER the ZSH_THEME and plugins variables are set.
source $ZSH/oh-my-zsh.sh
# User configuration, aliases, and functions should go AFTER sourcing Oh My Zsh.
# For zsh_codex plugin
bindkey '^X' create_completion
# rbenv
eval "$(rbenv init - zsh)"
# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/david/.lmstudio/bin"
# End of LM Studio CLI section
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
eval "$(zoxide init zsh)"

# ===== Modern CLI Tool Aliases & Configurations =====

# eza (better ls) aliases
alias ld='eza -lD'
alias lf='eza -lF --color=always | grep -v /'
alias lh='eza -dl .* --group-directories-first'
alias ll='eza -al --group-directories-first'
alias ls='eza -alF --color=always --sort=size | grep -v /'
alias lt='eza -al --sort=modified'

# bat (better cat) aliases
alias cat='bat --style=auto'
alias catp='bat --style=plain'  # cat with no decorations
alias bathelp='bat --plain --language=help'
help() {
    "$@" --help 2>&1 | bathelp
}

# ripgrep (better grep) aliases
alias grep='rg'
alias rgi='rg -i'  # case insensitive
alias rgl='rg -l'  # show only filenames

# fd (better find) aliases
alias find='fd'

# dust (better du) alias
alias du='dust'

# procs (better ps) alias
alias ps='procs'

# btop (better top) alias
alias top='btop'

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

# hstr - better command history
alias hh=hstr
setopt histignorespace
export HSTR_CONFIG=hicolor
export HSTR_TIOCSTI=y
bindkey -s "\C-r" "\C-a hstr -- \C-j"

# pv - pipe viewer for progress
# Usage: pv file.tar.gz | tar xzf -
# No aliases needed, use directly in pipes

