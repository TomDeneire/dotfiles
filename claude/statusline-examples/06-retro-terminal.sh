#!/usr/bin/env bash
# Retro terminal: monochrome amber/green CRT look, square brackets, no icons.
# The aesthetic a VT340 would have if it could run Claude Code.

input=$(cat)

RESET=$'\033[0m'
AMBER=$'\033[38;2;255;176;0m'
DIM_AMBER=$'\033[38;2;140;95;0m'

model=$(echo "$input" | jq -r '.model.display_name // "unknown"')
dir=$(echo "$input" | jq -r '.workspace.current_dir // ""')
dir="${dir##*/}"
pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

echo -e "${AMBER}[${model}]${RESET} ${DIM_AMBER}${dir}${RESET} ${AMBER}[CTX:${pct}%]${RESET}"
