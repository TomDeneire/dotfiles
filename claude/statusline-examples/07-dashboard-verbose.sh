#!/usr/bin/env bash
# Verbose dashboard: multi-line, shows almost everything available.
# This is the "I want to know everything" end of the spectrum.

input=$(cat)

RESET=$'\033[0m'
BOLD=$'\033[1m'
DIM=$'\033[2m'
CYAN=$'\033[36m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RED=$'\033[31m'

model=$(echo "$input" | jq -r '.model.display_name // "unknown"')
dir=$(echo "$input" | jq -r '.workspace.current_dir // ""')
dir="${dir##*/}"
pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
effort=$(echo "$input" | jq -r '.effort.level // "n/a"')

mins=$((duration_ms / 60000))
secs=$(((duration_ms % 60000) / 1000))

branch=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git branch --show-current 2>/dev/null)
fi

color_for() {
    local p=$1
    if (( $(echo "$p >= 80" | bc -l 2>/dev/null || echo 0) )); then echo "$RED"
    elif (( $(echo "$p >= 50" | bc -l 2>/dev/null || echo 0) )); then echo "$YELLOW"
    else echo "$GREEN"; fi
}

line1="${BOLD}${CYAN}${model}${RESET} ${DIM}effort:${effort}${RESET}  ${dir}"
[ -n "$branch" ] && line1="${line1}  ${DIM}git:${RESET}${branch}"

line2="${DIM}ctx${RESET} $(color_for "$pct")${pct}%${RESET}  ${DIM}cost${RESET} \$$(printf '%.2f' "$cost")  ${DIM}time${RESET} ${mins}m${secs}s"
[ -n "$five_pct" ] && line2="${line2}  ${DIM}5h${RESET} ${five_pct%.*}%"
[ -n "$week_pct" ] && line2="${line2}  ${DIM}7d${RESET} ${week_pct%.*}%"

echo -e "$line1"
echo -e "$line2"
