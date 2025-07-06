#!/bin/bash

# Base log directory
BASE_LOG_DIR="/var/log/monitoring"

# Get today's date (e.g., 2025-07-06)
TODAY=$(date +%F)

# Create daily folder: /var/log/monitoring/2025-07-06
DAILY_LOG_DIR="$BASE_LOG_DIR/$TODAY"

# Create the directory if it doesn't exist
if [ ! -d "$DAILY_LOG_DIR" ]; then
    echo "Creating log directory at $DAILY_LOG_DIR"
    sudo mkdir -p "$DAILY_LOG_DIR"
    sudo chmod 755 "$DAILY_LOG_DIR"
fi

# Get current time for file naming
TIMESTAMP=$(date +%H-%M-%S)

# File paths
TOP_LOG="$DAILY_LOG_DIR/top_$TIMESTAMP.log"
DF_LOG="$DAILY_LOG_DIR/df_$TIMESTAMP.log"
DU_LOG="$DAILY_LOG_DIR/du_$TIMESTAMP.log"
PROCESS_LOG="$DAILY_LOG_DIR/process_$TIMESTAMP.log"

# Generate monitoring logs
echo "Collecting system monitoring data..."

# Top command (CPU/mem/processes)
top -b -n1 > "$TOP_LOG"

# Disk usage
df -h > "$DF_LOG"

# Root folder size
du -sh / > "$DU_LOG"

# Top 10 memory-hungry processes
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 11 > "$PROCESS_LOG"

echo "Monitoring logs stored in $DAILY_LOG_DIR"
