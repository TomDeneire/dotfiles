# ~/.bashrc: executed by bash(1) for interactive shells

# Stop here for non-interactive shells
case $- in
*i*) ;;
*) return ;;
esac

# === Environment ===

# Prepend a directory to PATH unless it is already there
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

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set LS_COLORS, used by lsd
eval "$(dircolors -b)"

# Programmable completion
[ -f /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# === Prompt ===

# Print the battery percentage, if there is a battery
battery_status() {
    local p
    p=$(grep -m1 "POWER_SUPPLY_CAPACITY=" /sys/class/power_supply/BAT0/uevent 2>/dev/null)
    [ -n "$p" ] && printf "@ %s%%" "${p#*=}"
}

# Print the git branch and number of changed files, if inside a git repo
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

green_bold='\[\e[01;32m\]'
blue_bold='\[\e[01;34m\]'
clear='\[\e[00m\]'
MYHOST=$(. /etc/os-release && echo "$PRETTY_NAME")
PS1="\n${green_bold}\u${clear} on $MYHOST \$(battery_status)${blue_bold} \w${clear} \$(git_status)\n⚡ "
unset green_bold blue_bold clear

# === Aliases ===

# Replacement tools
alias ls='lsd'
alias l='ls -lAh --color=always'
alias cat="batcat --style=plain"
alias top='btop'
alias grep='grep --color=auto'

# Navigation
alias ..='cd ..'
alias cd..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias B='cd $HOME/.local/share/Trash/files'
alias C='cd $HOME/projects/code'
alias D='cd $HOME/Desktop'
alias Do='cd $HOME/Downloads'
alias Dc='cd $HOME/Documents'
alias P='cd $HOME/projects/'
alias T='cd $HOME/tmp'
alias W='cd $HOME/projects/websites'

# Other
alias tt='source $HOME/projects/code/bash/tt'

# === Functions ===

# List the directory contents after every cd
cd() {
    builtin cd "$@" && l
}

# Jump to a directory picked with djump
j() {
    local dir
    dir="$("$HOME/projects/code/rust/djump/target/release/djump")"
    if [ -n "$dir" ] && [ "$dir" != "$(pwd)" ]; then
        cd "$dir" || return
    fi
}

# Move files to the trash, ignoring rm flags (-r, -f, --) that gio trash does not accept
rm() {
    local arg
    local args=()
    for arg in "$@"; do
        [[ $arg =~ ^-[rRf]+$ || $arg == --recursive || $arg == --force || $arg == -- ]] || args+=("$arg")
    done
    gio trash "${args[@]}"
}

# Rerun the previous command and copy its output to the clipboard, e.g. `pwd` then `clip`.
# Asks for confirmation unless the command is known to be read-only.
clip() {
    local cmd first second reply safe=
    cmd=$(history -p '!!')
    read -r first second _ <<<"$cmd"

    case "$cmd" in
    # Chained commands, pipes and redirections can hide side effects
    *[\;\&\|\>\<\`]* | *'$('*) ;;
    *)
        case "$first" in
        pwd | ls | l | cat | echo | which | type | date | whoami | hostname | uname | wc | head | grep | tree | du | df) safe=1 ;;
        git)
            case "$second" in
            status | log | diff | show) safe=1 ;;
            esac
            ;;
        esac
        ;;
    esac

    if [ -z "$safe" ]; then
        read -r -p "Rerun '$cmd'? [y/N] " reply
        [[ $reply == [yY] ]] || return 1
    fi
    eval "$cmd" | xclip -selection clipboard >/dev/null 2>&1
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

# === Tools ===

# Zoxide
export _ZO_RESOLVE_SYMLINKS=1
eval "$(zoxide init bash)"

# Atuin (last, since it hooks into the prompt through its bundled bash-preexec)
eval "$(atuin init bash --disable-up-arrow --disable-ai)"
