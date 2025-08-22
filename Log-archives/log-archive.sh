#!/bin/bash
#
# log-archive.sh
# A CLI tool to archive and compress logs with retention + S3 sync
#

set -euo pipefail

# === Configurations ===
ARCHIVE_BASE="$HOME/log-archives"
RETENTION_DAYS=30
S3_BUCKET="s3://your-1/log-archives"

# === Functions ===
usage() {
    echo "Usage: $0 <log-directory>"
    exit 1
}

# === Main ===
if [ $# -ne 1 ]; then
    usage
fi

LOG_DIR=$1

# Verify directory exists
if [ ! -d "$LOG_DIR" ]; then
    echo "❌ Error: Directory '$LOG_DIR' does not exist."
    exit 1
fi

# Create archive directory
mkdir -p "$ARCHIVE_BASE"

# Timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Archive name
ARCHIVE_FILE="$ARCHIVE_BASE/logs_archive_${TIMESTAMP}.tar.gz"

# Compress logs
tar -czf "$ARCHIVE_FILE" -C "$LOG_DIR" .

# Log entry
LOGFILE="$ARCHIVE_BASE/archive.log"
echo "$(date +"%Y-%m-%d %H:%M:%S") Archived $LOG_DIR to $ARCHIVE_FILE" >> "$LOGFILE"

# Retention Policy (delete older than 30 days)
find "$ARCHIVE_BASE" -name "logs_archive_*.tar.gz" -type f -mtime +$RETENTION_DAYS -exec rm -f {} \;

# Upload to S3
if command -v aws &>/dev/null; then
    aws s3 cp "$ARCHIVE_FILE" "$S3_BUCKET/"
    echo "$(date +"%Y-%m-%d %H:%M:%S") Synced archive to $S3_BUCKET" >> "$LOGFILE"
else
    echo "⚠️ AWS CLI not installed. Skipping S3 sync." >> "$LOGFILE"
fi

echo "✅ Logs from '$LOG_DIR' archived to '$ARCHIVE_FILE'"
echo "📦 Uploaded to $S3_BUCKET"
echo "📜 Archive log saved at '$LOGFILE'"
