#!/usr/bin/env bash
# Git-focused: branch, staged/modified counts, and a PR badge if one's open.
# For people who, per the docs' own warning, have committed to the wrong
# branch before.

input=$(cat)

RESET=$'\033[0m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
BLUE=$'\033[34m'
DIM=$'\033[2m'

model=$(echo "$input" | jq -r '.model.display_name // "unknown"')
pr_number=$(echo "$input" | jq -r '.pr.number // empty')
pr_state=$(echo "$input" | jq -r '.pr.review_state // empty')

out="${DIM}[${model}]${RESET}"

if git rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git branch --show-current 2>/dev/null)
    staged=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
    modified=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')

    out="${out} ${BLUE}${branch}${RESET}"
    [ "$staged" -gt 0 ] && out="${out} ${GREEN}+${staged}${RESET}"
    [ "$modified" -gt 0 ] && out="${out} ${YELLOW}~${modified}${RESET}"
else
    out="${out} ${DIM}(no git repo)${RESET}"
fi

if [ -n "$pr_number" ]; then
    out="${out} ${DIM}|${RESET} PR #${pr_number} (${pr_state:-unknown})"
fi

echo -e "$out"
