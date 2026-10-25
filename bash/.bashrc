# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

j() {
    local dir
    dir="$("$HOME/projects/code/rust/djump/target/release/djump")"
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
    local MYSTATUS
    MYSTATUS=$(git status -sb --ignore-submodules 2>/dev/null | awk '
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
MYHOST=$(. /etc/os-release && echo "$PRETTY_NAME")

# Prompt
PS1="\n${green_bold}\u${clear} on $MYHOST \$(battery_status)${blue_bold} \w${clear} \$(git_status)\n⚡ "
unset green_bold blue_bold clear

# Set LS_COLORS, used by lsd
eval "$(dircolors -b)"

# Aliases
alias grep='grep --color=auto'
alias ls='lsd'
alias l='ls -lAh --color=always'
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias cat="batcat --style=plain"
alias B='cd $HOME/.local/share/Trash/files'
alias C='cd $HOME/projects/code'
alias D='cd $HOME/Desktop'
alias Do='cd $HOME/Downloads'
alias Dc='cd $HOME/Documents'
alias P='cd $HOME/projects/'
alias T='cd $HOME/tmp'
alias W='cd $HOME/projects/websites'
alias cd..='cd ..'
alias top='btop'
alias tt='source $HOME/projects/code/bash/tt'

# Move files to the trash, ignoring rm flags (-r, -f, --) that gio trash does not accept
rm() {
    local arg
    local args=()
    for arg in "$@"; do
        [[ $arg =~ ^-[rRf]+$ || $arg == --recursive || $arg == --force || $arg == -- ]] || args+=("$arg")
    done
    gio trash "${args[@]}"
}

# Copy stdin to the clipboard, e.g. `ls | clip`
clip() {
    xclip -selection clipboard >/dev/null
}

# Open all modified (staged or unstaged) and untracked files of the current git repo in nvim
nvimg() {
    local git_root files
    if ! git_root=$(git rev-parse --show-toplevel 2>/dev/null); then
        echo "nvimg: not inside a git repository" >&2
        return 1
    fi

    # Deleted files are excluded, since there is nothing left to edit
    files=$({
        git -C "$git_root" diff HEAD --name-only --diff-filter=d --no-color 2>/dev/null
        git -C "$git_root" ls-files --others --exclude-standard
    } | sort -u)

    if [ -z "$files" ]; then
        echo "nvimg: no modified or untracked files"
        return 0
    fi

    # xargs -o reopens the terminal as stdin so nvim keeps control of the TTY
    (builtin cd "$git_root" && xargs -o -d '\n' nvim <<<"$files")
}

cd() {
    builtin cd "$@" && l
}

# Environment variables
path_prepend() {
    case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
    esac
}
for dir in /snap/bin "$HOME/go/bin" "$HOME/projects/code/bash" "$HOME/bin" "$HOME/.local/bin" "$HOME/.cargo/bin" "$HOME/.atuin/bin"; do
    path_prepend "$dir"
done
unset dir
export PATH
export EDITOR='nvim'

# Programmable completion
[ -f /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# Zoxide
export _ZO_RESOLVE_SYMLINKS=1
eval "$(zoxide init bash)"

# Atuin
[[ -f "$HOME/.bash-preexec.sh" ]] && source "$HOME/.bash-preexec.sh"
eval "$(atuin init bash --disable-up-arrow --disable-ai)"
