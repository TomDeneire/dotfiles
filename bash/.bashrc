# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
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
xterm-color | *-256color | xterm-kitty) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

# if [ -n "$force_color_prompt" ]; then
#     if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
#         # We have color support; assume it's compliant with Ecma-48
#         # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
#         # a case would tend to support setf rather than setaf.)
#         color_prompt=yes
#     else
#         color_prompt=
#     fi
# fi

battery_status() {
    STATUS=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | awk {'print $2'})
    echo "@ $STATUS"
}

git_status() {
    MYSTATUS=$(git status -sb --untracked-files=no --ignore-submodules 2>/dev/null | awk '
    /^##/ { branch = substr($0, 4) }
    /^[[:space:]]+[A-Z]/ { count += gsub(/[[:upper:]]/, "", $1) }
    END { if (count > 0) printf("%s *%d", branch, count); else printf("%s", branch)}
    ')
    if [ "$MYSTATUS" != "" ]; then
        echo " ($MYSTATUS)"
    fi
}

# Color definitions

# black_bold='\[\e[01;30m\]'
# red_bold='\[\e[01;31m\]'
green_bold='\[\e[01;32m\]'
green_bg_black_fg='\[\e[42;30m\]'
blue_bg_green_fg='\[\e[44;32m\]'
blue_bg_black_fg='\[\e[44;30m\]'
# yellow_bold='\[\e[01;33m\]'
blue_bold='\[\e[01;34m\]'
blue='\[\e[01;34m\]'
# purple_bold='\[\e[01;35m\]'
# cyan_bold='\[\e[01;36m\]'
# white_bold='\[\e[01;37m\]'
# black='\[\e[00;30m\]'
# red='\[\e[00;31m\]'
# green='\[\e[00;32m\]'
# yellow='\[\e[00;33m\]'
# blue='\[\e[00;34m\]'
# purple='\[\e[00;35m\]'
# cyan='\[\e[00;36m\]'
# white='\[\e[00;37m\]'
clear='\[\e[00m\]'

# section_separators = { left = '', right = '' },
MYHOST=$(hostnamectl | grep Operating | cut -d ':' -f2 | cut -d 't' -f2)

if [ "$color_prompt" = yes ]; then
    # # version with slants
    # MYUSER="${debian_chroot:+($debian_chroot)}${green_bg_black_fg}\u on 󰣭$MYHOST \$(battery_status) ${blue_bg_green_fg}"
    # MYPATH="${blue_bg_black_fg}\w${clear}${blue}"
    # MYGIT="${clear} \$(git_status)"
    # PS1="\n$MYUSER$MYPATH$MYGIT\n⚡ "
    # version without slants
    PS1="\n${debian_chroot:+($debian_chroot)}${green_bold}\u ${clear}on 󰣭$MYHOST \$(battery_status)${blue_bold} \w${clear} \$(git_status)\n⚡ "
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

unset color_prompt
# unset force_color_prompt

# If this is an xterm set the title to user@host:dir
# case "$TERM" in
# xterm*|rxvt*)
#     PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
# ;;
# *)
# ;;
# esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='lsd'
    alias l='ls -lAh --color=always'
    alias grep='grep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Aliases
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias rm='gio trash'
alias cat="batcat --style=plain"
alias C='cd ~/projects/code'
alias D='cd ~/Desktop'
alias Do='cd ~/Downloads'
alias T='cd ~/tmp'
alias W='cd ~/projects/websites'
alias cd..='cd ..'
alias P='cd ~/projects/'
alias lazy='NVIM_APPNAME=lazyvim nvim'
alias top='btop'

cd() {
    builtin cd "$@" && l
}

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
# alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

# if [ -f ~/.bash_aliases ]; then
#     . ~/.bash_aliases
# fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
# if ! shopt -oq posix; then
#     if [ -f /usr/share/bash-completion/bash_completion ]; then
#         . /usr/share/bash-completion/bash_completion
#         elif [ -f /etc/bash_completion ]; then
#         . /etc/bash_completion
#     fi
# fi

# Environment variables

export PATH=/bin:/$HOME/.cargo/bin:/$HOME/.local/bin:/$HOME/bin:/$HOME/bin:/$HOME/projects/code/bash:/sbin:/snap/bin:/usr/bin:/usr/games:/usr/local/bin:/usr/local/games:/usr/local/sbin:/usr/sbin:/usr/local/go/bin:/$HOME/go/bin:$PATH
export PYTHONPATH=/$HOME/py3
export EDITOR='nvim'

# Fzf

# [ -f /$HOME/.fzf.bash ] && source /$HOME/.fzf.bash

# Zoxide

eval "$(zoxide init bash)"
export _ZO_RESOLVE_SYMLINKS=1

# Cargo

. "$HOME/.cargo/env"

# The next line updates PATH for the Google Cloud SDK.
# if [ -f '/$HOME/google-cloud-sdk/path.bash.inc' ]; then . '/$HOME/google-cloud-sdk/path.bash.inc'; fi

# Atuin
[[ -f /$HOME/.bash-preexec.sh ]] && source /$HOME/.bash-preexec.sh
export ATUIN_NOBIND="true"
eval "$(atuin init bash)"
# bind to ctrl-r, add any other bindings you want here too
bind -x '"\C-r": __atuin_history'

. "$HOME/.atuin/bin/env"
