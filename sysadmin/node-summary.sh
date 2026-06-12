#!/bin/bash
# One-shot node health summary — CPU, memory, disk, network, top processes.
# Great for quick triage when SSHing into an unfamiliar node.
#
# Usage:  ./node-summary.sh

set -euo pipefail

CYN='\033[0;36m'; GRN='\033[0;32m'; YEL='\033[0;33m'; RST='\033[0m'

divider() { echo -e "${CYN}── $1 $(printf '─%.0s' $(seq 1 $((50-${#1}))))${RST}"; }

echo ""
echo -e "${CYN}╔══════════════════════════════════════╗"
echo    "║  Node Summary: $(hostname)"
echo -e "╚══════════════════════════════════════╝${RST}"
echo "$(date)"
echo ""

divider "OS / Kernel"
echo "  OS:     $(grep PRETTY_NAME /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '"')"
echo "  Kernel: $(uname -r)"
echo "  Uptime: $(uptime -p 2>/dev/null || uptime)"
echo ""

divider "CPU"
echo "  Model:  $(grep 'model name' /proc/cpuinfo | head -1 | cut -d: -f2 | xargs)"
echo "  Cores:  $(nproc) logical"
echo "  Load:   $(cat /proc/loadavg | awk '{print $1,$2,$3}') (1m 5m 15m)"
echo ""

divider "Memory"
free -h | awk 'NR<=3{printf "  %-8s %8s %8s %8s\n",$1,$2,$3,$4}'
echo ""

divider "Disk"
df -h --output=source,size,used,avail,pcent,target 2>/dev/null | \
    grep -vE "tmpfs|udev|overlay" | head -8 | \
    awk 'NR==1{printf "  %-20s %6s %6s %6s %5s  %s\n",$1,$2,$3,$4,$5,$6; next}
              {printf "  %-20s %6s %6s %6s %5s  %s\n",$1,$2,$3,$4,$5,$6}'
echo ""

divider "Network interfaces"
ip -brief addr show 2>/dev/null | grep -v "^lo" | \
    awk '{printf "  %-12s %-10s %s\n",$1,$2,$3}'
echo ""

divider "Top 5 CPU processes"
ps aux --sort=-%cpu 2>/dev/null | \
    awk 'NR==1{printf "  %-10s %5s %5s %s\n","USER","CPU%","MEM%","COMMAND"; next}
         NR<=6{printf "  %-10s %5s %5s %s\n",$1,$3,$4,$11}'
echo ""

divider "Top 5 memory processes"
ps aux --sort=-%mem 2>/dev/null | \
    awk 'NR==1{printf "  %-10s %5s %5s %s\n","USER","CPU%","MEM%","COMMAND"; next}
         NR<=6{printf "  %-10s %5s %5s %s\n",$1,$3,$4,$11}'
echo ""
