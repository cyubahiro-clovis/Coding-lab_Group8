#!/bin/bash

# Member 4 - The Archivist
# Purpose: Rotates logs from active_logs to archived_logs with timestamps

TIMESTAMP=$(date +"%Y%m%d_%H%M")

echo "=== Starting Log Rotation — $TIMESTAMP ==="

for log_file in active_logs/*.log; do
    [ -f "$log_file" ] || continue      # skip if no .log files exist

    base=$(basename "$log_file" .log)   # e.g. heart_rate
    dest="archived_logs/${base}_${TIMESTAMP}.log"

    echo "Archiving: $log_file → $dest"
    mv "$log_file" "$dest"

    touch "$log_file"
    echo "Recreated empty: $log_file"
done

echo ""
echo "✅ Log rotation complete — $(date)"
