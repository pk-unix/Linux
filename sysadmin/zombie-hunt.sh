#!/bin/bash
# Find zombie processes and identify their parent (the process that should reap them).
#
# Usage:  ./zombie-hunt.sh

set -euo pipefail

YEL='\033[0;33m'; RED='\033[0;31m'; GRN='\033[0;32m'; RST='\033[0m'

echo "=== Zombie Process Hunt: $(hostname) ==="
echo ""

zombies=$(ps axo pid,ppid,user,stat,comm | awk '$4~/Z/{print}')

if [[ -z "$zombies" ]]; then
    echo -e "${GRN}✓  No zombie processes found.${RST}"
    exit 0
fi

count=$(echo "$zombies" | wc -l)
echo -e "${YEL}Found $count zombie(s):${RST}"
echo ""
printf "  %-8s %-8s %-12s %-6s %s\n" "PID" "PPID" "USER" "STAT" "COMMAND"
echo "$zombies" | while read -r pid ppid user stat comm; do
    parent_cmd=$(ps -o comm= -p "$ppid" 2>/dev/null || echo "?")
    parent_user=$(ps -o user= -p "$ppid" 2>/dev/null || echo "?")
    printf "  %-8s %-8s %-12s %-6s %-20s  ← parent: PID %s (%s, %s)\n" \
        "$pid" "$ppid" "$user" "$stat" "$comm" "$ppid" "$parent_user" "$parent_cmd"
done

echo ""
echo -e "${YEL}To resolve:${RST}"
echo "  kill -CHLD <PPID>   # signal parent to reap"
echo "  kill -TERM <PPID>   # or terminate the parent"
