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

alias ls='eza --icons'
alias ll='eza --icons -l'
alias lt='eza --icons --tree'


# Add all your plugins to this one list.
# I have merged your two lists and removed the conflicting syntax highlighter.
plugins=(
  git
  npm
  node
  z
  thefuck
  virtualenv
  web-search
  zsh-autosuggestions
  fast-syntax-highlighting
  zsh_codex
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

# Function to unlock Bitwarden and export the session key
# This function is correct, well done!
bwu() {
  export BW_SESSION=$(bw unlock --raw)
  if [[ -n "$BW_SESSION" ]]; then
    echo "✅ Bitwarden vault unlocked."
  else
    echo "❌ Failed to unlock Bitwarden vault."
  fi
}

# Function to get a password from Bitwarden by its item name
getpw() {
  bw get password "$1"
}

# Function to SSH into the NAS using a specific ID from Bitwarden
sshnas() {
  # Paste the correct ID from your error message here.
  # This is more specific than using a name.
  local itemID="05d37c88-c9c0-48d8-ae50-b0dd0055d7fd"

  echo "➡️  Fetching password fo rLilNasX...."
  # Note: We now call 'bw get' directly with the ID.
  sshpass -p "$(bw get password "$itemID")" ssh admir@192.168.1.249
}


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

eval "$(zoxide init zsh)"
