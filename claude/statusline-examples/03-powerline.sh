#!/usr/bin/env bash
# Powerline-style: solid color blocks joined by the classic arrow separator.
# Requires a Nerd Font / Powerline-patched font for the  / arrow glyphs
# to render as triangles instead of boxes.

input=$(cat)

RESET=$'\033[0m'
FG_BLACK=$'\033[30m'
FG_WHITE=$'\033[97m'
BG_BLUE=$'\033[44m'
BG_GREEN=$'\033[42m'
BG_YELLOW=$'\033[43m'
FG_BLUE=$'\033[34m'
FG_GREEN=$'\033[32m'
FG_YELLOW=$'\033[33m'

ARROW=$''

model=$(echo "$input" | jq -r '.model.display_name // "unknown"')
dir=$(echo "$input" | jq -r '.workspace.current_dir // ""')
dir="${dir##*/}"
pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

branch=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git branch --show-current 2>/dev/null)
fi

segment1="${BG_BLUE}${FG_WHITE} ${model} ${RESET}${FG_BLUE}${ARROW}${RESET}"
segment2="${BG_GREEN}${FG_BLACK} ${dir} ${RESET}${FG_GREEN}${ARROW}${RESET}"

if [ -n "$branch" ]; then
    segment2="${BG_GREEN}${FG_BLACK} ${dir} ${RESET}${FG_GREEN}${ARROW}${RESET}"
    segment3="${BG_YELLOW}${FG_BLACK} ${branch} ${RESET}${FG_YELLOW}${ARROW}${RESET}"
    echo -e "${segment1}${segment2}${segment3} ${pct}% ctx"
else
    echo -e "${segment1}${segment2} ${pct}% ctx"
fi
