#!/usr/bin/env bash
# Cyberpunk: neon magenta/cyan on black, glitchy brackets, truecolor.
# Requires a 24-bit truecolor terminal (most modern ones are).

input=$(cat)

RESET=$'\033[0m'
# Truecolor escapes: \033[38;2;R;G;Bm
NEON_PINK=$'\033[38;2;255;0;170m'
NEON_CYAN=$'\033[38;2;0;255;255m'
NEON_YELLOW=$'\033[38;2;255;255;0m'
DIM_GRAY=$'\033[38;2;100;100;100m'

model=$(echo "$input" | jq -r '.model.display_name // "unknown"')
pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')

# Glitch-bar: solid blocks in neon cyan, empty in dim gray
width=10
filled=$((pct * width / 100))
bar=""
for ((i=0; i<filled; i++)); do bar="${bar}▓"; done
for ((i=filled; i<width; i++)); do bar="${bar}░"; done

out="${NEON_PINK}⟨${RESET}${NEON_CYAN}${model}${RESET}${NEON_PINK}⟩${RESET}"
out="${out} ${DIM_GRAY}//${RESET} ${NEON_CYAN}${bar}${RESET} ${NEON_YELLOW}${pct}%${RESET}"

if [ -n "$five_pct" ]; then
    out="${out} ${DIM_GRAY}//${RESET} ${NEON_PINK}5H:${five_pct%.*}%${RESET}"
fi

echo -e "$out"
