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

# Replacement tools and more sane defaults
alias ls='lsd'
alias l='ls -lAh --color=auto'
alias cat='batcat --style=plain'
alias top='btop'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias ping='ping -c 5'
alias mkdir='mkdir -p'

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

# List a large directory compactly in as many columns as fit the terminal,
# shortening names longer than 15 characters to their start and end (e.g. another..ame.py)
ll() {
    \ls -1 | \
    awk -v width="$(tput cols)" '
    function shorten(name,    dot, ext, base, tail) {
        if (length(name) <= 15) return name
        dot = match(name, /\.[^.]*$/)
        if (dot > 0) {
            ext = substr(name, dot)
            base = substr(name, 1, dot - 1)
            tail = substr(base, length(base) - 1) ext
        } else {
            tail = substr(name, length(name) - 1)
        }
        return substr(name, 1, 7) ".." tail
    }
    {
        names[NR] = shorten($0)
        if (length(names[NR]) > max)
            max = length(names[NR])
    }
    END {
        colwidth = max + 2
        cols = int((width + 2) / colwidth)
        if (cols < 1) cols = 1
        rows = int((NR + cols - 1) / cols)
        for (r = 1; r <= rows; r++) {
            line = ""
            for (c = 0; c < cols; c++) {
                i = c * rows + r
                if (i <= NR)
                    line = line sprintf("%-*s", colwidth, names[i])
            }
            sub(/ +$/, "", line)
            print line
        }
    }'
}

# Put a command output in the clipboard (e.g. `pwd | c`)
c() {
    if command -v xclip >/dev/null 2>&1; then
        printf '%s' "$(cat)" | xclip -selection clipboard
    elif command -v pbcopy >/dev/null 2>&1; then
        printf '%s' "$(cat)" | pbcopy
    elif command -v wl-copy >/dev/null 2>&1; then
        printf '%s' "$(cat)" | wl-copy
    elif command -v xsel >/dev/null 2>&1; then
        printf '%s' "$(cat)" | xsel --clipboard --inpu
    else
        echo "c: no clipboard tool found" >&2
        return 1
    fi
}

# Jump to a directory picked with djump
j() {
    local dir
    dir="$("$HOME/projects/code/rust/djump/target/release/djump")"
    if [ -n "$dir" ] && [ "$dir" != "$(pwd)" ]; then
        cd "$dir" || return
    fi
}

# Move files to the trash, ignoring rm flags (-r, -f, --)
# that gio trash does not accept
rm() {
    local arg
    local args=()
    for arg in "$@"; do
        if [[ $arg =~ ^-[rRf]+$ ]] ||
           [[ $arg == "--recursive" ]] ||
           [[ $arg == "--force" ]] ||
           [[ $arg == "--" ]]; then
            continue
        fi
        args+=("$arg")
    done
    gio trash "${args[@]}"
}

# Open all modified (staged or unstaged) and untracked files
# of the current git repo in nvim
nvimg() {
    local git_root files
    if ! git_root=$(git rev-parse --show-toplevel 2>/dev/null); then
        echo "nvimg: not inside a git repository" >&2
        return 1
    fi

    # Deleted files are excluded, since there is nothing left to edit
    files=$({
        git -C "$git_root" diff HEAD \
            --name-only \
            --diff-filter=d \
            --no-color 2>/dev/null
        git -C "$git_root" ls-files \
            --others \
            --exclude-standard
    } | sort -u)

    if [ -z "$files" ]; then
        echo "nvimg: no modified or untracked files"
        return 0
    fi

    # xargs -o reopens the terminal as stdin
    # so nvim keeps control of the TTY
    (
        builtin cd "$git_root" && \
        xargs -o -d '\n' nvim <<<"$files"
    )
}

# === Tools ===

# Zoxide
export _ZO_RESOLVE_SYMLINKS=1
eval "$(zoxide init bash)"

# Atuin (last, since it hooks into the prompt through its bundled bash-preexec)
eval "$(atuin init bash --disable-up-arrow --disable-ai)"
