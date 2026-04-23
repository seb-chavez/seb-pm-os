#!/usr/bin/env bash
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "unknown"')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
folder=$(basename "$cwd")
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0')

# Scale: 80% real = 100% displayed. Clamp to 100.
scaled=$(echo "$used_pct" | awk '{v = $1 / 0.8; if (v > 100) v = 100; printf "%d", v}')

# Bar: 10 chars
filled=$(echo "$scaled" | awk '{n = int($1 / 10 + 0.5); if (n > 10) n = 10; print n}')
empty=$((10 - filled))
bar=""
for i in $(seq 1 "$filled"); do bar="${bar}█"; done
for i in $(seq 1 "$empty"); do bar="${bar}░"; done

# ANSI codes
DIM="\033[2m"
RESET="\033[0m"
GREEN="\033[32m"
YELLOW="\033[33m"
ORANGE="\033[38;5;208m"
RED_BLINK="\033[31;5m"
BRIGHT="\033[1m"

# Pick bar color based on scaled percentage
if [ "$scaled" -ge 95 ]; then
  bar_color="$RED_BLINK"
  skull=" 💀"
elif [ "$scaled" -ge 65 ]; then
  bar_color="$ORANGE"
  skull=""
elif [ "$scaled" -ge 50 ]; then
  bar_color="$YELLOW"
  skull=""
else
  bar_color="$GREEN"
  skull=""
fi

printf "${DIM}%s${RESET} | ${DIM}%s${RESET} | ${BRIGHT}${bar_color}%s${RESET} ${BRIGHT}${bar_color}%d%%${RESET}%s" \
  "$model" "$folder" "$bar" "$scaled" "$skull"
