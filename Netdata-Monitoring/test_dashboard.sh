#!/bin/bash
# test_dashboard.sh - Generate load to test Netdata monitoring

set -e

echo "=== Generating CPU Load for 30s ==="
if ! command -v stress &>/dev/null; then
  echo "Installing stress tool..."
  sudo apt-get install -y stress || sudo yum install -y stress
fi

# Stress CPU (2 cores) for 30 seconds
stress --cpu 2 --timeout 30 &

# Generate disk I/O
dd if=/dev/zero of=/tmp/testfile bs=1M count=200 oflag=direct &

# Generate memory load
stress --vm 1 --vm-bytes 256M --timeout 60 &

wait
echo "=== Load test complete. Check your Netdata dashboard ==="
