#!/bin/bash
# Compact status line with colors

input=$(cat)

# ANSI colors
RESET='\033[0m'
CYAN='\033[36m'
DIM='\033[2m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'

# Extract values
MODEL=$(echo "$input" | jq -r '.model.display_name // "?"')
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
CTX_REMAINING=$(echo "$input" | jq -r '.context_window.remaining_percentage // 100' | cut -d. -f1)
IN_TOK=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
OUT_TOK=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
CACHE_READ=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0')

# Format cost
COST_FMT=$(printf "%.2f" "$COST")

# Color for remaining context (green > 50, yellow > 20, red <= 20)
if [ "$CTX_REMAINING" -gt 50 ]; then
  CTX_COLOR=$GREEN
elif [ "$CTX_REMAINING" -gt 20 ]; then
  CTX_COLOR=$YELLOW
else
  CTX_COLOR=$RED
fi

# Format token counts (k for thousands)
format_tokens() {
  local n=$1
  if [ "$n" -ge 1000000 ]; then
    printf "%.1fM" "$(echo "scale=1; $n/1000000" | bc)"
  elif [ "$n" -ge 1000 ]; then
    printf "%.1fk" "$(echo "scale=1; $n/1000" | bc)"
  else
    echo "$n"
  fi
}

IN_FMT=$(format_tokens "$IN_TOK")
OUT_FMT=$(format_tokens "$OUT_TOK")

# Cache indicator with count
if [ "$CACHE_READ" -gt 0 ]; then
  CACHE_FMT=$(format_tokens "$CACHE_READ")
  CACHE_IND="${GREEN}✓${RESET}${DIM}${CACHE_FMT}${RESET}"
else
  CACHE_IND="${DIM}-${RESET}"
fi

# Output: Model | $cost | ctx% left | ↑in ↓out | cache
echo -e "\n${CYAN}${MODEL}${RESET} ${DIM}|${RESET} \$${COST_FMT} ${DIM}|${RESET} ${CTX_COLOR}${CTX_REMAINING}% left${RESET} ${DIM}|${RESET} ${DIM}↑${IN_FMT} ↓${OUT_FMT}${RESET} ${CACHE_IND}"
