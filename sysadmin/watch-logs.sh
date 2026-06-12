#!/bin/bash
# Tail multiple log files at once with color-coded output per file.
# Each file gets a distinct prefix so you can see which log a line came from.
#
# Usage:
#   ./watch-logs.sh /var/log/syslog /var/log/auth.log
#   ./watch-logs.sh /var/log/*.log

set -euo pipefail

COLORS=("\033[0;32m" "\033[0;36m" "\033[0;33m" "\033[0;35m" "\033[0;34m" "\033[1;32m")
RST="\033[0m"

[[ $# -eq 0 ]] && { echo "Usage: $0 <file1> [file2] ..."; exit 1; }

i=0
pids=()
for f in "$@"; do
    [[ -f "$f" ]] || { echo "Skipping: $f (not found)"; continue; }
    color="${COLORS[$((i % ${#COLORS[@]}))]}"
    label=$(basename "$f")
    tail -F "$f" 2>/dev/null | while IFS= read -r line; do
        printf "${color}[%-20s]${RST} %s\n" "$label" "$line"
    done &
    pids+=($!)
    (( i++ )) || true
done

trap 'kill "${pids[@]}" 2>/dev/null' EXIT INT TERM
wait
