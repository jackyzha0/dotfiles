# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/jzhao/.oh-my-zsh"

export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true
plugins=(git zsh-autosuggestions zsh-nvm zsh-syntax-highlighting)

export DISABLE_AUTO_UPDATE=true
source $ZSH/oh-my-zsh.sh

export VISUAL=/usr/local/bin/nvim

# symbols for starship
eval "$(starship init zsh)"

export NVM_DIR="$HOME/.nvm"
export GOPATH=/Users/$USER/go
export PATH=$GOPATH/bin:$PATH
export PATH=$PATH:$HOME/.local/bin

alias v="nvim"
alias chrome="open -a \"Google Chrome\""
alias ls="eza -lahF"
alias l="eza -lahF"
alias ll="eza -lahF"
alias headers="httpstat"
alias cat="bat -fP"
alias gds="gd --staged"
alias procs="procs --watch --sortd cpu"
alias save="ga . && gc -m"

cd ~/projects

# bun completions
[ -s "/Users/jzhao/.bun/_bun" ] && source "/Users/jzhao/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

[ -f "/Users/jzhao/.ghcup/env" ] && . "/Users/jzhao/.ghcup/env" # ghcup-env

eval "$(direnv hook zsh)"
