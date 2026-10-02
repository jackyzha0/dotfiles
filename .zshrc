# Hand-rolled config (oh-my-zsh retired 2026-08-13; rollback: ~/.config/.zshrc.omz-backup)

# --- environment
export VISUAL=/usr/local/bin/nvim
export GOPATH=/Users/$USER/go
export PATH=$GOPATH/bin:$PATH
export PATH=$PATH:$HOME/.local/bin

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env" # ghcup-env
source $HOME/google-cloud-sdk/path.zsh.inc

# node via fnm (repo work still gets its node from nix/direnv, which prepends later)
eval "$(fnm env --use-on-cd)"

# --- options & history (atuin is the primary history; the file is a fallback)
setopt auto_cd interactive_comments extended_glob
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt inc_append_history hist_ignore_all_dups hist_ignore_space extended_history

# --- completion: trust the cached dump (-C); full fpath re-scan at most once a day
autoload -Uz compinit
_zcd=$HOME/.zcompdump
if [[ -n $_zcd(#qN.mh+24) ]]; then
  compinit -d $_zcd && touch $_zcd
else
  compinit -C -d $_zcd
fi
unset _zcd

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun" # bun completions

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu no # fzf-tab renders the menu
zstyle ':completion:*:descriptions' format '[%d]'
source ~/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh

# --- plugins
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# --- keybindings
bindkey -e
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word  # ctrl-right
bindkey '^[[1;5D' backward-word # ctrl-left
bindkey '^[[1;3C' forward-word  # alt-right
bindkey '^[[1;3D' backward-word # alt-left

# --- aliases
source ~/.zsh/git-helpers.zsh # git_current_branch etc. (from omz lib/git.zsh)
source ~/.zsh/git-aliases.zsh # ga/gc/gd/gst/... (from omz git plugin)

alias v="nvim"
alias chrome="open -a \"Google Chrome\""
alias ls="eza -lahF"
alias l="eza -lahF"
alias ll="eza -lahF"
alias headers="httpstat"
alias gds="gd --staged"
alias procs="procs --watch --sortd cpu"
alias save="ga . && gc -m"
alias vm="ssh jzhao-vm-with-ports"
alias magicarp="TERM=xterm-256color sshpass -p 'Letmein123!' ssh gearados@gearados-nx.tail62d295.ts.net"

# --- prompt & tools
eval "$(starship init zsh)"
eval "$(atuin init zsh --disable-up-arrow)" # ctrl-r; drop the flag to give atuin up-arrow too
eval "$(direnv hook zsh)"

# must be sourced last (wraps ZLE widgets)
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

cd ~/projects
