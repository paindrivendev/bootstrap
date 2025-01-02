# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Created by newuser for 5.8
source ~/.config/antigen.zsh
# plugin management
antigen use oh-my-zsh
antigen bundle git
antigen bundle command-not-found
antigen bundle docker-compose
antigen bundle extract
antigen bundle fzf
antigen bundle git
antigen bundle magic-enter
antigen bundle hlissner/zsh-autopair
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle HeroCC/LS_COLORS
antigen theme romkatv/powerlevel10k
antigen apply
# config
export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1
export EDITOR="nvim"
export FZF_DEFAULT_COMMAND="ag -l --nogroup --column"
export FZF_CTRL_R_OPTS="--sort"
export HISTFILE=~/.zsh_history
export HISTFILESIZE=1000000000
export HISTSIZE=1000000000
export HISTTIMEFORMAT="[%F %T] "
export VISUAL=$EDITOR
setopt EXTENDED_HISTORY
setopt HIST_BEEP
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Use vi mode 
bindkey -v
# Kill the lag
export KEYTIMEOUT=1
# Use vim keys in tab complete menu:
bindkey -M menuselect 'j' vi-backward-char
bindkey -M menuselect 'l' vi-up-line-or-history
bindkey -M menuselect ';' vi-forward-char
bindkey -M menuselect 'k' vi-down-line-or-history
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^w' backward-kill-word
bindkey '^u' backward-kill-line
#bindkey '^r' history-incremental-search-backward
# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^o' edit-command-line
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

typeset - gA ZSH_HIGHLIGHT_STYLES[arg0]=fg=#00B4EB

alias jca-prod='ssh experteer@jca.experteer.com'
alias pjpp='cd ~/workspace/new-dev/experteer-dev/pjpp'
alias jca='cd ~/workspace/experteer-dev/jobcontentapp/'
alias jca-stage='ssh experteer@192.168.100.168'
alias jakob='ssh experteer@jakob.experteer.com'
alias louise='ssh experteer@louise.experteer.com'
alias marie='ssh experteer@marie.experteer.com'
alias dev='ssh -A -l experteer stage.experteer.com'
alias kafka='ssh -A experteer@kafka-analysis.experteer.com'
alias kafka2='ssh experteer@kafka0.experteer.com'
alias ysf2='ssh -A experteer@ysfdocker.experteer.com'
alias ysf='ssh -A experteer@192.168.100.96'
alias ysf2='ssh -A experteer@192.168.100.95'
alias dwh='ssh experteer@192.168.200.207'
alias jca-stage='ssh -A experteer@192.168.100.168'
alias dev-home=' ssh -A yacik@dev.experteer.com'
alias dev-exp='ssh -A experteer@dev.experteer.com'
alias jiggle='ssh -A experteer@dev.experteer.com'
alias ls='lsd'
alias lss='ls'
alias cat='bat'
alias t="tmux"
alias ta="tmux a -t"
alias tls="tmux ls"
alias tn="tmux new -t"
alias tk="tmux kill-session -t"
alias tks="tmux kill-server"
alias v="nvim"
alias vn="nvim -u NONE"
alias notes="v /home/ysf/delete/notes/time.txt"
alias vim=nvim
alias vpn-server="ssh experteer@192.168.100.95"

alias screenshot="scrot ~/screenshots/%Y-%m-%d-screenshot.png"
# alias gcloud="docker run -it -v /home/ysf/.config/gcloud:/home/cloudsdk/.config/gcloud --rm connect-test gcloud"
# alias gcli="/home/ysf/workspace/experteer-dev/gcloud-cli/bin/gcloud-cli"
export CLOUDSDK_PYTHON="3.12.6"

alias dkill="docker kill $(docker ps -q)"

export EDITOR='nvim'
export PATH="/bin:/usr/bin:/usr/local/bin:${PATH}"
export VISUAL=nvim;
export EDITOR=nvim;
export GOPATH=$HOME/go
export GOBIN=$HOME/go/bin
export PATH=$GOPATH/bin:/usr/local/go/bin:$PATH
export MYVIMRC=$HOME/.config/nvim/init.vim
source /usr/share/fzf/key-bindings.zsh
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"
eval "$(rbenv init -)"
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh


