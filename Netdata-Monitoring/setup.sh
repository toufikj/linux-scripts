#!/bin/bash
# setup.sh - Install Netdata monitoring agent

set -e

echo "=== Installing Netdata ==="

# Update system
sudo apt-get update -y || sudo yum update -y

# Install prerequisites
if command -v apt-get &>/dev/null; then
  sudo apt-get install -y curl
elif command -v yum &>/dev/null; then
  sudo yum install -y curl
fi

# Run Netdata kickstart installer
bash <(curl -Ss https://my-netdata.io/kickstart.sh) --dont-wait

echo "=== Netdata installation complete ==="
echo "Access the dashboard at: http://localhost:19999"
