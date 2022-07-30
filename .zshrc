# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/jzhao/.oh-my-zsh"
ZSH_THEME="spaceship"

export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true
plugins=(zsh-nvm git npm rust golang brew docker zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

alias v="nvim"
alias chrome="open -a \"Google Chrome\""

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# symbols for starship
eval "$(starship init zsh)"

export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


eval "$(pyenv init --path)"
eval "$(pyenv init -)"
[ -f "/Users/jzhao/.ghcup/env" ] && source "/Users/jzhao/.ghcup/env" # ghcup-env

export GOPATH=/Users/$USER/go
export PATH=$GOPATH/bin:$PATH

alias ls="exa -lahF"
alias l="exa -lahF"
alias ll="exa -lahF"
alias headers="httpstat"
alias cgrep="grep --color=always"
