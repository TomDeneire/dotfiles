#!/usr/bin/env bash
# Playful: a kaomoji cat whose mood tracks your context window usage.
# Loosely inspired by the "claude-cat" npm package's kawaii usage display.
# No Nerd Font required — just emoji and kaomoji, so it works everywhere.

input=$(cat)

RESET=$'\033[0m'
DIM=$'\033[2m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RED=$'\033[31m'

model=$(echo "$input" | jq -r '.model.display_name // "unknown"')
pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

if [ "$pct" -lt 30 ]; then
    cat="(=^･ω･^=)"
    mood="purring"
    color="$GREEN"
elif [ "$pct" -lt 60 ]; then
    cat="(=｀ω´=)"
    mood="watching you work"
    color="$GREEN"
elif [ "$pct" -lt 85 ]; then
    cat="(=；ェ；=)"
    mood="getting nervous"
    color="$YELLOW"
else
    cat="(=ｘェｘ=)"
    mood="about to /compact you"
    color="$RED"
fi

echo -e "${color}${cat}${RESET} 🐾 ${model} ${DIM}· ${pct}% full, ${mood}${RESET}"
