# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
#HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# command history size
HISTSIZE=999999

# timestamps in history
HISTTIMEFORMAT='%b %e %H:%M  '

# extended globbing
shopt -s extglob

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    #PS1="${debian_chroot:+($debian_chroot)}\[\e[32;1m\]\u\[\e[0m\]@\[\e[37;1m\]\h\[\e[0m\]:\[\e[34;1m\]\w\`parse_git_branch\`\[\e[32;1m\]\\$\[\e[0m\] "
    PROMPT_COMMAND=parse_prompt
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    #PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Load aliases from a shell-neutral aliases file
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# display git branch dirty state in bash prompt
export GIT_PS1_SHOWDIRTYSTATE=1

# function to print a colourised PS1 with current git branch etc
function parse_prompt {
    PS1="${debian_chroot:+($debian_chroot)}\[$BGreen\]\u\[$Colour_Off\]@\[$BWhite\]\h\[$Colour_Off\]:\[$BBlue\]\w"
    
    if [ "$(type -t __git_ps1)" == 'function' ]; then
        if ! git status 2>/dev/null | grep -q 'nothing to commit (working directory clean)'; then
            PS1="$PS1$BPurple`__git_ps1`$Colour_Off"
        else
            PS1="${PS1}`__git_ps1`"
        fi
    fi

    PS1="$PS1\[$BGreen\]\\$\[$Colour_Off\] "

    # If this is an xterm set the title to user@host:dir
    case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    *)
        ;;
    esac
}

# Load environment variables
[ -e "${HOME}/.env" ] && source "${HOME}/.env"

# direnv
#which direnv 2>/dev/null 1>/dev/null && eval "$(direnv hook bash)"

# Load goenv
[ -n "${GOENV_ROOT}" ] && eval "$(goenv init -)"

# Load rbenv
which rbenv 2>/dev/null 1>/dev/null && eval "$(rbenv init -)"
[ -e /usr/local/Cellar/rbenv/1.0.0/completions/rbenv.bash ] && source /usr/local/Cellar/rbenv/1.0.0/completions/rbenv.bash

# pyenv
[ -n "${PYENV_ROOT}" ] && eval "$(pyenv init -)"

# Prompt
source "${HOME}/.liquidprompt/liquidprompt"

# Load site-local bashrc
[ -e "${HOME}/.bashrc.local" ] && source "${HOME}/.bashrc.local"

# Be truthful
true

# vim: set ts=2 sts=2 sw=2 et:
