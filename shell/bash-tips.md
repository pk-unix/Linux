# Bash Tips & One-liners

Practical bash tricks for Linux sysadmins and HPC users.

---

## Process & Job Control

```bash
# Run command immune to hangups (keep running after logout)
nohup ./long-script.sh > out.log 2>&1 &

# Disown a running job so it survives logout
some-long-command &
disown %1

# Background + redirect output
command > output.log 2>&1 &
echo "PID: $!"

# Wait for all background jobs
wait
echo "All done"

# Run N parallel jobs with a simple pool
for item in a b c d e f; do
    do_work "$item" &
    # Limit to 4 parallel jobs
    while (( $(jobs -r | wc -l) >= 4 )); do sleep 0.1; done
done
wait
```

## Loops

```bash
# Loop over a range
for i in {1..10}; do echo $i; done

# Loop with padding (001, 002, …)
for i in $(seq -w 1 100); do echo "node-$i"; done

# Loop over files matching a pattern
for f in /var/log/*.log; do
    echo "Processing $f"
done

# Loop over lines in a file
while IFS= read -r line; do
    echo "→ $line"
done < hostlist.txt

# Loop over command output
while IFS= read -r host; do
    ssh "$host" "hostname; uptime"
done < <(cat hosts.txt)
```

## String Manipulation

```bash
# Extract filename without extension
f="/path/to/file.tar.gz"
echo "${f##*/}"          # file.tar.gz   (basename)
echo "${f%.*}"           # /path/to/file.tar
echo "${f%%.*}"          # /path/to/file
echo "${f##*.}"          # gz            (extension)

# String substitution
s="hello world"
echo "${s/world/linux}"  # hello linux
echo "${s^^}"            # HELLO WORLD   (uppercase)
echo "${s,,}"            # hello world   (lowercase)

# Trim whitespace
s="  hello  "
echo "${s// /}"          # hello  (remove all spaces)
echo "${s#"${s%%[! ]*}"}"  # leading trim
```

## Redirections

```bash
# Redirect stdout and stderr
command > out.log 2>&1

# Redirect stderr only
command 2> err.log

# Append to file
command >> out.log 2>&1

# Discard output
command > /dev/null 2>&1

# Pipe stderr through a command
command 2>&1 | grep ERROR

# Tee — write to file AND stdout
command | tee output.log

# Here-string
grep "pattern" <<< "some string to search"

# Process substitution — treat command output as a file
diff <(ssh host1 cat /etc/hosts) <(ssh host2 cat /etc/hosts)
```

## Conditionals

```bash
# File tests
[[ -f file ]]   # exists and is regular file
[[ -d dir  ]]   # exists and is directory
[[ -s file ]]   # exists and non-empty
[[ -r file ]]   # readable
[[ -x file ]]   # executable
[[ -L link ]]   # is a symlink

# String tests
[[ -z "$s" ]]   # empty string
[[ -n "$s" ]]   # non-empty string
[[ "$a" == "$b" ]]
[[ "$a" =~ ^[0-9]+$ ]]  # regex match

# Arithmetic
(( x > 5 ))
(( x++ ))

# Short-circuit
command && echo "success" || echo "failed"
[[ -f file ]] || { echo "file missing"; exit 1; }
```

## SSH tricks

```bash
# SSH with a specific key
ssh -i ~/.ssh/my_key user@host

# SSH tunnel — forward remote port 8080 to local 8080
ssh -L 8080:localhost:8080 user@remotehost

# Reverse tunnel — expose local port to remote
ssh -R 9090:localhost:9090 user@remotehost

# Jump host / bastion
ssh -J user@bastion user@target

# Run command on multiple hosts in parallel
parallel-ssh -h hosts.txt -l user "uptime"

# Copy file to multiple hosts
for host in $(cat hosts.txt); do
    scp file.txt "$host:/tmp/" &
done; wait

# Persistent SSH connection (reuse for speed)
# In ~/.ssh/config:
# Host *
#   ControlMaster auto
#   ControlPath ~/.ssh/sockets/%r@%h:%p
#   ControlPersist 10m
```

## awk one-liners

```bash
# Print specific columns
awk '{print $1, $3}' file.txt

# Sum a column
awk '{sum+=$2} END{print sum}' file.txt

# Filter lines where column 3 > 100
awk '$3 > 100' file.txt

# Print lines between two patterns
awk '/START/,/END/' file.txt

# Count unique values in column 1
awk '{count[$1]++} END{for(k in count) print count[k], k}' file.txt | sort -rn
```

## find tricks

```bash
# Find and delete files older than 30 days
find /tmp -type f -mtime +30 -delete

# Find large files (>1GB)
find / -type f -size +1G -printf '%s %p\n' 2>/dev/null | sort -rn

# Find recently modified files
find . -type f -newer /tmp/reference_file

# Find and run a command on each result
find . -name "*.log" -exec gzip {} \;

# Find files owned by a user
find /home -user username -type f

# Find broken symlinks
find . -xtype l
```

## Misc

```bash
# Repeat a command every N seconds
watch -n 5 'df -h'

# Time a command
time ./script.sh

# Run command N times
for i in {1..5}; do ./benchmark.sh; done

# Check if a process is running
pgrep -x "process_name" > /dev/null && echo "running" || echo "not running"

# Get external IP
curl -s ifconfig.me

# Quick HTTP server in current directory
python3 -m http.server 8080

# Count lines / words / chars
wc -l file.txt
wc -w file.txt

# Sort and deduplicate
sort file.txt | uniq
sort -rn numbers.txt    # numeric reverse sort

# Compare two files
diff file1 file2
comm -23 <(sort file1) <(sort file2)  # lines only in file1
```
