#zmodload zsh/zprof

# emacs key mode
bindkey -e

# Word boundary characters
WORDCHARS='*?_[]~&;!#$%^'

# Auto change into directories
setopt autocd

# Globbing
setopt extendedglob # extended globbing
setopt nomatch      # error on unmatched

# Interactive comments
setopt interactivecomments

# History
HISTFILE=~/.zsh_history
HISTSIZE=9000000
SAVEHIST=9000000
setopt extended_history      # save history timestamps and duration
setopt inc_append_history    # save history after each command
setopt hist_ignore_dups      # no duplicates
setopt histignorespace       # space-prepended not retained
alias history="history -i 0" # show full history by default, with timestamps

# Bash-like comments
setopt interactivecomments

# No beeping
unsetopt beep

# Don't bug about using `rm *`
unsetopt normstarsilent

# Prompt
fpath+=($HOME/.zsh/pure)
autoload -U promptinit; promptinit
prompt pure

# Autocompletion
fpath=("${HOME}/.zsh/completions" $fpath)
autoload -Uz compinit && if ! [[ -e "${HOME}/zcompdump" ]] || [[ -n "${HOME}/.zcompdump"(#qN.mh+24) ]]; then compinit; else compinit -C; fi
#autoload -Uz compinit && compinit
autoload -Uz +X bashcompinit && bashcompinit

# Menu-based completion
zstyle ':completion:*' menu select

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# List processes when killing
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# Autocomplete aliased commands
setopt completealiases

# Autosuggestions
[[ -f "${HOME}/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
  source "${HOME}/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"

# fzf
which fzf 2>/dev/null 1>/dev/null && source <(fzf --zsh)

# Local bash-style completions
#if [[ -d "${HOME}/.bash-completions" ]]; then
#  for F in "${HOME}/.bash-completions"/*; do
#    source "${F}"
#  done
#fi

# Search history on up or down
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# fn-arrow keys on Macbook
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# home and end in remote terminal
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line

# delete key
bindkey "\e[3~" delete-char

# ctrl-u behaviour like bash
bindkey \^U backward-kill-line

# Command editing using C-x C-e
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# Syntax highlighting
[[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# SSH agent
[[ -f "${HOME}/.ssh/environment" ]] && \
  source "${HOME}/.ssh/environment" >/dev/null

# Environment variables
[[ -e "${HOME}/.env" ]] && source "${HOME}/.env"

# direnv
#which direnv 2>/dev/null 1>/dev/null && eval "$(direnv hook zsh)"

# Load goenv
if [[ -d "${GOENV_ROOT}" ]]; then
  export GOENV_DISABLE_GOPATH=1
  [[ -n "${GOENV_ROOT}" ]] && eval "$(goenv init -)"
fi

# Load rbenv
#which rbenv 2>/dev/null 1>/dev/null && eval "$(rbenv init -)"
#[[ -e /usr/local/Cellar/rbenv/1.0.0/completions/rbenv.zsh ]] && source /usr/local/Cellar/rbenv/1.0.0/completions/rbenv.zsh

# Load pyenv
if which pyenv-virtualenv-init 1>/dev/null 2>/dev/null; then
  eval "$(pyenv virtualenv-init -)"
  eval "$(pyenv init --path)"
elif [[ -x "${PYENV_ROOT}/bin/pyenv" ]]; then
  eval "$("${PYENV_ROOT}/bin/pyenv" virtualenv-init -)"
  eval "$("${PYENV_ROOT}/bin/pyenv" init -)"
fi
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# Conda
if [[ -e "${HOME}/opt/anaconda3/bin/conda" ]]; then
  __conda_setup="$("${HOME}/opt/anaconda3/bin/conda" shell.zsh hook 2>/dev/null)"
  if [ $? -eq 0 ]; then
    eval "$__conda_setup"
  elif [ -f "${HOME}/opt/anaconda3/etc/profile.d/conda.sh" ]; then
    . "${HOME}/opt/anaconda3/etc/profile.d/conda.sh"
  else
    export PATH="${HOME}/opt/anaconda3/bin:${PATH}"
  fi
  unset __conda_setup
fi

# Load asdf
#[[ -f "${HOME}/.asdf/asdf.sh" ]] && source "${HOME}/.asdf/asdf.sh"
#[[ -f "${HOME}/.asdf/completions/asdf.sh" ]] && source "${HOME}/.asdf/completions/asdf.sh"

# AWS CLI completion
#which aws_zsh_completer.sh 2>/dev/null 1>/dev/null && source "$(which aws_zsh_completer.sh)"

# Azure CLI completion (very slow)
#[[ -f "${HOME}/.az.completion" ]] && source "${HOME}/.az.completion"

# Shell functions
source "${HOME}/.functions"

# Shell aliases
source "${HOME}/.aliases"

# iTerm2 shell integration
[[ "${TERM_PROGRAM}" == "iTerm.app" ]] && \
  source "${HOME}/.iterm2_shell_integration.zsh"

# Colours
#[[ -f "${HOME}/.base16-shell/base16-bright.dark.sh" ]] && \
#  source "${HOME}/.base16-shell/base16-bright.dark.sh"

# Tab/window title
if [[ -n "${ITERM_SESSION_ID}" ]]; then
  DISABLE_AUTO_TITLE="true"
  precmd
fi

# Site-local zshrc
[[ -e "${HOME}/.zshrc.local" ]] && source "${HOME}/.zshrc.local"

true

#zprof

# vim: set ft=zsh ts=2 sts=2 sw=2 et:
