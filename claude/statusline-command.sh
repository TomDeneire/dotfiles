#!/usr/bin/env bash

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "unknown model"')

# ANSI colors
RESET=$'\033[0m'
BOLD=$'\033[1m'
DIM=$'\033[2m'
CYAN=$'\033[36m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RED=$'\033[31m'

# Render a colored usage bar using block glyphs, width 10.
# Color shifts green -> yellow -> red as usage rises.
usage_bar() {
    local pct=$1
    local width=10
    local filled
    filled=$(printf "%.0f" "$(echo "$pct $width" | awk '{printf "%f", $1 * $2 / 100}')")
    [ "$filled" -gt "$width" ] && filled=$width
    local empty=$(( width - filled ))

    local color="$GREEN"
    awk_cmp=$(echo "$pct" | awk '{ if ($1 >= 80) print "red"; else if ($1 >= 50) print "yellow"; else print "green" }')
    case "$awk_cmp" in
        red) color="$RED" ;;
        yellow) color="$YELLOW" ;;
        green) color="$GREEN" ;;
    esac

    local bar=""
    local i
    for (( i=0; i<filled; i++ )); do bar="${bar}█"; done
    local rest=""
    for (( i=0; i<empty; i++ )); do rest="${rest}░"; done
    printf "%s%s%s%s%s" "$color" "$bar" "$DIM" "$rest" "$RESET"
}

ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

out="${model}"

if [ -n "$ctx_pct" ]; then
    out="${out}  ${DIM}ctx${RESET} $(usage_bar "$ctx_pct") $(printf '%3.0f' "$ctx_pct")%"
fi

if [ -n "$five_pct" ]; then
    out="${out}  ${DIM}5h${RESET} $(usage_bar "$five_pct") $(printf '%3.0f' "$five_pct")%"
fi

if [ -n "$week_pct" ]; then
    out="${out}  ${DIM}7d${RESET} $(usage_bar "$week_pct") $(printf '%3.0f' "$week_pct")%"
fi

printf "%s" "$out"
