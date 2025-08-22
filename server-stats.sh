#!/bin/bash
#
# server-stats.sh
# Script to analyse basic server performance stats
#

echo "======================================="
echo " Server Performance Stats - $(hostname)"
echo " Date: $(date)"
echo "======================================="

# ---- OS and uptime ----
echo
echo ">>> OS and Uptime"
echo "OS Version   : $(cat /etc/*release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"')"
echo "Kernel       : $(uname -r)"
echo "Uptime       : $(uptime -p)"
echo "Load Average : $(uptime | awk -F'load average:' '{ print $2 }')"

# ---- CPU Usage ----
echo
echo ">>> CPU Usage"
mpstat 1 1 | awk '/Average/ {printf "User: %.1f%% | System: %.1f%% | Idle: %.1f%% | iowait: %.1f%%\n", $3, $5, $12, $6}'

# ---- Memory Usage ----
echo
echo ">>> Memory Usage"s
free -h | awk 'NR==2{printf "Used: %s | Free: %s | Usage: %.2f%%\n", $3, $4, $3*100/$2 }'

# ---- Disk Usage ----
echo
echo ">>> Disk Usage"
df -h --total | grep total | awk '{printf "Used: %s | Free: %s | Usage: %s\n", $3, $4, $5}'

# ---- Top 5 Processes by CPU ----
echo
echo ">>> Top 5 Processes by CPU Usage"
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6

# ---- Top 5 Processes by Memory ----
echo
echo ">>> Top 5 Processes by Memory Usage"
ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -n 6

# ---- Stretch Goals ----
echo
echo ">>> Logged in Users"
who | awk '{print $1}' | sort | uniq -c

echo
echo ">>> Failed Login Attempts (last 10)"
if command -v journalctl &> /dev/null; then
    journalctl -u ssh -n 10 --no-pager | grep "Failed password"
elif [ -f /var/log/auth.log ]; then
    grep "Failed password" /var/log/auth.log | tail -10
elif [ -f /var/log/secure ]; then
    grep "Failed password" /var/log/secure | tail -10
else
    echo "No log source for failed attempts found."
fi

echo
echo "======================================="
echo " End of Report"
echo "======================================="
