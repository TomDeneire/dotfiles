#!/usr/bin/env bash
# The full unixporn treatment: boxed widget, Nerd Font icons for everything
# the JSON gives you, a real battery reading pulled straight from the OS,
# and one line of pure flex at the bottom. This is the "my rice is better
# than your productivity" script.
#
# Requires: jq, a Nerd Font, a truecolor terminal. Battery segment only
# shows on a laptop with a standard /sys/class/power_supply battery.

input=$(cat)

RESET=$'\033[0m'
BOLD=$'\033[1m'
DIM=$'\033[2m'
CYAN=$'\033[38;2;137;220;235m'
GREEN=$'\033[38;2;166;227;161m'
YELLOW=$'\033[38;2;249;226;175m'
RED=$'\033[38;2;243;139;168m'
MAUVE=$'\033[38;2;203;166;247m'
BORDER=$'\033[38;2;88;91;112m'

# Nerd Font (Font Awesome range, stable across versions)
ICON_LINUX=$''
ICON_CUBE=$''
ICON_GIT=$''
ICON_CLOCK=$''
ICON_BOLT=$''
ICON_DOLLAR=$''
ICON_CHIP=$''
ICON_FIRE=$''
ICON_BATTERY_FULL=$''
ICON_BATTERY_HALF=$''
ICON_BATTERY_LOW=$''

model=$(echo "$input" | jq -r '.model.display_name // "unknown"')
dir=$(echo "$input" | jq -r '.workspace.current_dir // ""')
dir="${dir##*/}"
pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
effort=$(echo "$input" | jq -r '.effort.level // "n/a"')
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
hit_ratio=$(echo "$input" | jq -r '.prompt_cache.hit_ratio // empty')

mins=$((duration_ms / 60000))

branch=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git branch --show-current 2>/dev/null)
fi

# Real battery reading, if one exists (laptops only)
battery=""
bat_path=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -n1)
if [ -n "$bat_path" ] && [ -f "$bat_path/capacity" ]; then
    bat_pct=$(cat "$bat_path/capacity" 2>/dev/null)
    if [ -n "$bat_pct" ]; then
        if [ "$bat_pct" -ge 66 ]; then bat_icon="$ICON_BATTERY_FULL"
        elif [ "$bat_pct" -ge 33 ]; then bat_icon="$ICON_BATTERY_HALF"
        else bat_icon="$ICON_BATTERY_LOW"; fi
        battery="  ${GREEN}${bat_icon} ${bat_pct}%${RESET}"
    fi
fi

ctx_color="$GREEN"
[ "$pct" -ge 50 ] && ctx_color="$YELLOW"
[ "$pct" -ge 80 ] && ctx_color="$RED"

line1="${BORDER}╭─${RESET} ${CYAN}${ICON_LINUX}${RESET} ${BOLD}${model}${RESET} ${DIM}${ICON_CUBE} ${dir}${RESET}"
[ -n "$branch" ] && line1="${line1} ${MAUVE}${ICON_GIT} ${branch}${RESET}"

line2="${BORDER}│${RESET}  ${ctx_color}${pct}% ctx${RESET}  ${ICON_CHIP} ${effort}  ${ICON_DOLLAR}$(printf '%.2f' "$cost")  ${ICON_CLOCK} ${mins}m${battery}"
[ -n "$five_pct" ] && line2="${line2}  ${ICON_BOLT} 5h:${five_pct%.*}%"
[ -n "$week_pct" ] && line2="${line2} 7d:${week_pct%.*}%"

flex="${BORDER}╰─${RESET} ${YELLOW}${ICON_FIRE}${RESET} "
if [ -n "$hit_ratio" ]; then
    hit_pct=$(printf '%.0f' "$(echo "$hit_ratio * 100" | bc -l 2>/dev/null || echo 0)")
    flex="${flex}${DIM}cache hit ${hit_pct}% — I don't miss${RESET}"
else
    flex="${flex}${DIM}ricing level: maximum${RESET}"
fi

echo -e "$line1"
echo -e "$line2"
echo -e "$flex"
