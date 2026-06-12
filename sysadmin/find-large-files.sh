#!/bin/bash
# Find large files and directories on any filesystem.
#
# Usage:
#   ./find-large-files.sh                    # top 20 files in current dir
#   ./find-large-files.sh /scratch/username  # specific path
#   ./find-large-files.sh /tmp --dirs        # top directories instead
#   ./find-large-files.sh /var --older 30    # files older than 30 days

set -euo pipefail

PATH_ARG="${1:-.}"
MODE="${2:---files}"
EXTRA="${3:-}"

case "$MODE" in
    --dirs)
        echo "=== Top 20 directories by size under $PATH_ARG ==="
        du -h --max-depth=3 "$PATH_ARG" 2>/dev/null | sort -rh | head -20
        ;;
    --older)
        DAYS="${EXTRA:-30}"
        echo "=== Files older than $DAYS days under $PATH_ARG ==="
        find "$PATH_ARG" -type f -mtime "+$DAYS" -printf '%s %p\n' 2>/dev/null | \
            sort -rn | head -20 | \
            awk '{s=$1; sub(/^[^ ]+ /,"",$0);
                  if(s>1073741824) printf "%8.1f GB  %s\n",s/1073741824,$0;
                  else if(s>1048576) printf "%8.1f MB  %s\n",s/1048576,$0;
                  else printf "%8.1f KB  %s\n",s/1024,$0}'
        ;;
    *)
        echo "=== Top 20 largest files under $PATH_ARG ==="
        find "$PATH_ARG" -type f -printf '%s %p\n' 2>/dev/null | \
            sort -rn | head -20 | \
            awk '{s=$1; sub(/^[^ ]+ /,"",$0);
                  if(s>1073741824) printf "%8.1f GB  %s\n",s/1073741824,$0;
                  else if(s>1048576) printf "%8.1f MB  %s\n",s/1048576,$0;
                  else printf "%8.1f KB  %s\n",s/1024,$0}'
        ;;
esac
