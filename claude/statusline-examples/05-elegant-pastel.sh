#!/usr/bin/env bash
# Elegant / soft: pastel truecolor, thin dot separators, no harsh brackets.
# Requires a 24-bit truecolor terminal.

input=$(cat)

RESET=$'\033[0m'
DUSTY_ROSE=$'\033[38;2;217;164;178m'
LAVENDER=$'\033[38;2;181;166;217m'
SAGE=$'\033[38;2;168;197;170m'
CREAM=$'\033[38;2;230;220;200m'

model=$(echo "$input" | jq -r '.model.display_name // "unknown"')
dir=$(echo "$input" | jq -r '.workspace.current_dir // ""')
dir="${dir##*/}"
pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

branch=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git branch --show-current 2>/dev/null)
fi

SEP="${CREAM} · ${RESET}"

out="${DUSTY_ROSE}${model}${RESET}${SEP}${LAVENDER}${dir}${RESET}"
[ -n "$branch" ] && out="${out}${SEP}${SAGE}${branch}${RESET}"
out="${out}${SEP}${CREAM}${pct}% context${RESET}"

echo -e "$out"
