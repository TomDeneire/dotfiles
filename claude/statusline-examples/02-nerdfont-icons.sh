#!/usr/bin/env bash
# Icon-heavy: a Nerd Font glyph in front of every segment.
# Requires a Nerd Font (https://www.nerdfonts.com/) in your terminal, or the
# icons render as boxes/question marks.

input=$(cat)

RESET=$'\033[0m'
CYAN=$'\033[36m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
MAGENTA=$'\033[35m'

# Nerd Font glyphs (Font Awesome set): microchip, open-folder, git-branch, bolt, dollar
ICON_MODEL=$''
ICON_DIR=$''
ICON_GIT=$''
ICON_CTX=$''
ICON_COST=$''

model=$(echo "$input" | jq -r '.model.display_name // "unknown"')
dir=$(echo "$input" | jq -r '.workspace.current_dir // ""')
dir="${dir##*/}"
pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')

branch=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git branch --show-current 2>/dev/null)
fi

out="${MAGENTA}${ICON_MODEL} ${model}${RESET}"
out="${out}  ${CYAN}${ICON_DIR} ${dir}${RESET}"
[ -n "$branch" ] && out="${out}  ${GREEN}${ICON_GIT} ${branch}${RESET}"
out="${out}  ${YELLOW}${ICON_CTX} ${pct}%${RESET}"
out="${out}  ${ICON_COST} $(printf '%.2f' "$cost")"

echo -e "$out"
