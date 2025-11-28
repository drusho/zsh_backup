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
# eza aliases
alias ld='eza -lD'
alias lf='eza -lF --color=always | grep -v /'
alias lh='eza -dl .* --group-directories-first'
alias ll='eza -al --group-directories-first'
alias ls='eza -alF --color=always --sort=size | grep -v /'
alias lt='eza -al --sort=modified'

