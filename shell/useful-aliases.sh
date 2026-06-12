#!/bin/bash
# useful-aliases.sh — Shell aliases and functions for Linux power users.
# Source this file or add to ~/.bashrc / ~/.zshrc:
#   source ~/Linux/shell/useful-aliases.sh

# ── Navigation ───────────────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ll='ls -lhF --color=auto'
alias la='ls -lhAF --color=auto'
alias lt='ls -lhFt --color=auto'           # sort by time
alias lS='ls -lhFS --color=auto'           # sort by size
alias tree1='tree -L 1'
alias tree2='tree -L 2'

# ── Safety ───────────────────────────────────────────────────────────────────
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# ── System info ──────────────────────────────────────────────────────────────
alias meminfo='free -h && echo "" && cat /proc/meminfo | grep -E "MemTotal|MemFree|MemAvailable|SwapTotal|SwapFree|HugePages"'
alias cpuinfo='lscpu | grep -E "Model name|Socket|Core|Thread|CPU MHz|NUMA"'
alias diskinfo='df -hT | grep -vE "tmpfs|udev"'
alias netinfo='ip -brief addr && echo "" && ip route'
alias openports='ss -tulnp'
alias whousing='lsof +D'                   # lsof +D /path — who has files open
alias psmem='ps aux --sort=-%mem | head -15'
alias pscpu='ps aux --sort=-%cpu | head -15'

# ── Files ────────────────────────────────────────────────────────────────────
alias duh='du -h --max-depth=1 | sort -rh'   # disk usage of current dir
alias biggest='find . -type f -printf "%s %p\n" | sort -rn | head -20 | numfmt --to=iec --field=1'
alias recent='find . -type f -newer /tmp -printf "%T@ %p\n" | sort -rn | head -20 | cut -d" " -f2-'

# ── Processes ────────────────────────────────────────────────────────────────
alias pstree='pstree -p'
alias killall9='killall -9'
alias zombie='ps axo stat,ppid,pid,comm | grep -w Z'

# ── Network ──────────────────────────────────────────────────────────────────
alias myip='curl -s ifconfig.me'
alias listening='ss -tulnp | grep LISTEN'
alias connections='ss -tnp | grep ESTAB'
alias pingg='ping -c 4 8.8.8.8'

# ── Shortcuts ────────────────────────────────────────────────────────────────
alias h='history | tail -30'
alias hgrep='history | grep'
alias reload='source ~/.bashrc'
alias path='echo $PATH | tr ":" "\n"'
alias now='date +"%Y-%m-%d %H:%M:%S"'
alias week='date +%V'

# ── Grep with color ───────────────────────────────────────────────────────────
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# ── Tar shortcuts ────────────────────────────────────────────────────────────
alias tarc='tar -czf'         # tarc archive.tar.gz dir/
alias tarx='tar -xzf'         # tarx archive.tar.gz
alias tarl='tar -tzf'         # tarl archive.tar.gz — list contents

# ── Functions ────────────────────────────────────────────────────────────────

# mkcd — mkdir + cd in one
mkcd() { mkdir -p "$1" && cd "$1"; }

# extract — universal archive extractor
extract() {
    [[ -f "$1" ]] || { echo "Not a file: $1"; return 1; }
    case "$1" in
        *.tar.gz|*.tgz)  tar -xzf "$1"  ;;
        *.tar.bz2|*.tbz) tar -xjf "$1"  ;;
        *.tar.xz)        tar -xJf "$1"  ;;
        *.tar)           tar -xf  "$1"  ;;
        *.zip)           unzip    "$1"  ;;
        *.gz)            gunzip   "$1"  ;;
        *.bz2)           bunzip2  "$1"  ;;
        *.xz)            unxz     "$1"  ;;
        *.7z)            7z x     "$1"  ;;
        *)               echo "Unknown format: $1" ;;
    esac
}

# psgrep — grep processes by name, excluding the grep itself
psgrep() { ps aux | grep -v grep | grep -i "$1"; }

# portcheck — check if a port is open on a host
portcheck() { nc -zv "${1:-localhost}" "${2:-80}" 2>&1; }

# sshretry — SSH with auto-retry (useful for nodes rebooting)
sshretry() {
    local host=$1; shift
    until ssh "$host" "$@"; do
        echo "Retrying in 5s…"; sleep 5
    done
}

# fhere — find file by name in current directory
fhere() { find . -iname "*${1}*" 2>/dev/null; }

# countdown — countdown timer
countdown() {
    local secs=${1:-10}
    while (( secs > 0 )); do
        printf "\r%3d seconds remaining…" "$secs"
        sleep 1; (( secs-- ))
    done
    echo -e "\rDone!                  "
}
