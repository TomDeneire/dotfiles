#!/usr/bin/env bash
# Minimal: model name + context percentage. Nothing else. No colors, no icons.
# Good baseline before you start adding anything.

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "unknown"')
pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

echo "$model | ${pct}% context"
