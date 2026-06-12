# Linux

General-purpose Linux sysadmin scripts, shell utilities, Ansible playbooks, and bash tips. No GPU or HPC-specific content here — see [gpu-toolkit](https://github.com/pk-unix/gpu-toolkit) and [hpc-toolkit](https://github.com/pk-unix/hpc-toolkit) for that.

---

## Contents

### `sysadmin/` — Day-to-day ops scripts
| Script | What it does |
|---|---|
| `node-summary.sh` | One-shot node triage: OS, CPU, memory, disk, network, top processes |
| `find-large-files.sh` | Hunt down disk hogs — by file, by directory, or by age |
| `zombie-hunt.sh` | Find zombie processes and identify the parent that should reap them |
| `watch-logs.sh` | Tail multiple log files simultaneously with color-coded prefixes |

### `shell/` — Shell productivity
| File | What it does |
|---|---|
| `useful-aliases.sh` | Aliases and bash functions for daily use — source in `.bashrc` |
| `bash-tips.md` | Bash one-liners, awk/find/ssh tricks, loops, redirections reference |

### `ansible/` — Ansible playbooks
Playbooks for common Linux admin tasks: package management, firewall rules, cron jobs, user management, cleanup scripts.

---

## Quick usage

```bash
git clone https://github.com/pk-unix/Linux.git
cd Linux
chmod +x sysadmin/*.sh

# Triage any node instantly
./sysadmin/node-summary.sh

# Find what's eating disk space
./sysadmin/find-large-files.sh /var --dirs

# Watch multiple logs at once
./sysadmin/watch-logs.sh /var/log/syslog /var/log/auth.log

# Load aliases into your shell
source shell/useful-aliases.sh
# Or add to ~/.bashrc:
echo 'source ~/Linux/shell/useful-aliases.sh' >> ~/.bashrc
```

---

## Related repos

- **[gpu-toolkit](https://github.com/pk-unix/gpu-toolkit)** — nvidia-smi diagnostics, Xid watchers, GPU process mapping
- **[hpc-toolkit](https://github.com/pk-unix/hpc-toolkit)** — NUMA tuning, huge pages, InfiniBand, CPU governors, HPC sysctl configs
