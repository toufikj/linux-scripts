#!/bin/bash
# cleanup.sh - Remove Netdata from system

set -e

echo "=== Stopping Netdata ==="
sudo systemctl stop netdata || true

echo "=== Removing Netdata ==="
sudo systemctl disable netdata || true
sudo rm -rf /opt/netdata
sudo rm -rf /etc/netdata
sudo rm -rf /var/lib/netdata
sudo rm -rf /var/log/netdata
sudo rm -rf /usr/lib/netdata
sudo rm -f /etc/systemd/system/netdata.service

echo "=== Netdata removed successfully ==="
