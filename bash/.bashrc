# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return;;
esac

# History settings
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
# HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
# shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
# HISTSIZE=1000
# HISTFILESIZE=2000
# HISTTIMEFORMAT="%d/%m/%y %T "

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color|*-256color|xterm-kitty) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

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

# Color definitions

# black_bold='\[\033[01;30m\]'
# red_bold='\[\033[01;31m\]'
green_bold='\[\033[01;32m\]'
# yellow_bold='\[\033[01;33m\]'
blue_bold='\[\033[01;34m\]'  
# purple_bold='\[\033[01;35m\]'
# cyan_bold='\[\033[01;36m\]'
# white_bold='\[\033[01;37m\]'
# black='\[\033[00;30m\]'
# red='\[\033[00;31m\]'
green='\[\033[00;32m\]'
# yellow='\[\033[00;33m\]'
# blue='\[\033[00;34m\]'
# purple='\[\033[00;35m\]'
# cyan='\[\033[00;36m\]'
# white='\[\033[00;37m\]'
clear='\[\033[00m\]'

battery_status() {
    echo $(batman check --icon 2> /dev/null)
}

git_status() {
    MYSTATUS=$(git status -sb --untracked-files=no --ignore-submodules 2> /dev/null | awk '
    /^##/ { branch = substr($0, 4) }
    /^[[:space:]]+[A-Z]/ { count += gsub(/[[:upper:]]/, "", $1) }
    END { if (count > 0) printf("%s *%d", branch, count); else printf("%s", branch)}
    ')
    if [ "$MYSTATUS" != "" ]; then
        echo " ($MYSTATUS)"
    fi
}

# MYHOST=$(hostnamectl | grep Operating | cut -d':' -f2)
MYHOST=$(hostnamectl | grep Operating | cut -d ':' -f2 | cut -d 't' -f2)

if [ "$color_prompt" = yes ]; then
    PS1="\n${debian_chroot:+($debian_chroot)}${green_bold}\u ${clear}on 󰣭$MYHOST \$(battery_status) ${blue_bold} \w${clear} \$(git_status)\n⚡ "
    # PS1="\n${debian_chroot:+($debian_chroot)}${green_bold}\u ${clear}on 🐧$MYHOST \$(battery_status) ${blue_bold} \w${clear} \$(git_status)\n⚡ "
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
;;
*)
;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='lsd'
    alias l='ls -lah --color=always'
    alias grep='grep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Aliases
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias j='cd $(cdjumper fuzzy)'
alias rm='gio trash'
alias cat="batcat --style=plain"
alias B='cd ~/Dropbox/brocade/source/data'
alias C='cd ~/projects/code'
alias D='cd ~/Desktop'
alias Do='cd ~/Downloads'
alias T='cd ~/tmp'
alias W='cd ~/projects/websites'
alias cd..='cd ..'
alias P='cd ~/projects/'
alias N='cd ~/Documents/notes'
alias Q='cd ~/Dropbox/brocade/packages/go/brocade.be/qtechng'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
# alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
        elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi


# Environment variables

export PATH=/bin:/home/tdeneire/.cargo/bin:/home/tdeneire/.local/bin:/home/tdeneire/bin:/home/tdeneire/bin:/home/tdeneire/projects/code/bash:/sbin:/snap/bin:/usr/bin:/usr/games:/usr/local/bin:/usr/local/games:/usr/local/sbin:/usr/sbin:/usr/local/go/bin:/home/tdeneire/go/bin:$PATH
export BROCADE_REGISTRY=/home/tdeneire/registry.json
export PYTHONPATH=/home/tdeneire/py3
export EDITOR='nvim'

# Fzf

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Zoxide

eval "$(zoxide init bash)"
export _ZO_RESOLVE_SYMLINKS=1

# Cargo

. "$HOME/.cargo/env"

# The next line updates PATH for the Google Cloud SDK.
# if [ -f '/home/tdeneire/google-cloud-sdk/path.bash.inc' ]; then . '/home/tdeneire/google-cloud-sdk/path.bash.inc'; fi

# Atuin
[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
export ATUIN_NOBIND="true"
eval "$(atuin init bash)"
# bind to ctrl-r, add any other bindings you want here too
bind -x '"\C-r": __atuin_history'
source /home/tdeneire/perl5/perlbrew/etc/bashrc
