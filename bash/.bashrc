# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

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

j() {
    local dir
    dir="$(/home/tdeneire/projects/code/rust/djump/target/release/djump)"
    if [ -n "$dir" ] && [ "$dir" != "$(pwd)" ]; then
        cd "$dir" || return
    fi
}

battery_status() {
    local p
    p=$(grep -m1 "POWER_SUPPLY_CAPACITY=" /sys/class/power_supply/BAT0/uevent 2>/dev/null)
    [ -n "$p" ] && printf "@ %s%%" "${p#*=}"
}

git_status() {
    MYSTATUS=$(git status -sb --untracked-files=no --ignore-submodules 2>/dev/null | awk '
    /^##/ { branch = substr($0, 4) }
    /^[^#]/ { count++ }
    END { if (count > 0) printf("%s *%d", branch, count); else printf("%s", branch)}
    ')
    if [ "$MYSTATUS" != "" ]; then
        echo " ($MYSTATUS)"
    fi
}

# Color definitions (static)
green_bold='\[\e[01;32m\]'
blue_bold='\[\e[01;34m\]'
clear='\[\e[00m\]'

# OS name (static, computed once)
. /etc/os-release
MYHOST="$PRETTY_NAME"

# Precompute static prompt components
STATIC_DEBIAN_CHROOT=${debian_chroot:+($debian_chroot)}
STATIC_USER="${green_bold}\u${clear}"
STATIC_ON="on $MYHOST"
STATIC_BLUE="${blue_bold}"
STATIC_CLEAR="${clear}"

# Prompt
if [ "$color_prompt" = yes ]; then
    PS1="\n${STATIC_DEBIAN_CHROOT}${STATIC_USER} ${STATIC_ON} \$(battery_status)${STATIC_BLUE} \w${STATIC_CLEAR} \$(git_status)\n⚡ "
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

unset color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias grep='grep --color=auto'
fi

# Aliases
alias ls='lsd'
alias l='ls -lAh --color=always'
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
alias top='btop'
alias tt='source /home/tdeneire/projects/code/bash/tt'

cd() {
    builtin cd "$@" && l
}

# Environment variables
export PATH="$HOME/.local/bin:$HOME/bin:$HOME/projects/code/bash:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$HOME/go/bin"
export PYTHONPATH="$HOME/py3"
export EDITOR='nvim'

# Zoxide
export _ZO_RESOLVE_SYMLINKS=1
eval "$(zoxide init bash)"

# Cargo
. "$HOME/.cargo/env"

# Atuin
[[ -f "$HOME/.bash-preexec.sh" ]] && source "$HOME/.bash-preexec.sh"
export ATUIN_NOBIND="true"
eval "$(atuin init bash)"
# bind to ctrl-r, add any other bindings you want here too
bind -x '"\C-r": __atuin_history'
. "$HOME/.atuin/bin/env"

