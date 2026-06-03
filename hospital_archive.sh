#!/bin/bash

# ====================================================================
# Script: hospital_archive.sh
# Author: Ryan Prince Gakire
# Role: Member 4 - The Archivist
# Purpose: Rotates logs from active_logs to archived_logs with timestamps
# ====================================================================

TIMESTAMP=$(date +"%Y%m%d_%H%M")

echo "=== Starting Log Rotation — $TIMESTAMP ==="

# Loop through every .log file in active_logs
for log_file in active_logs/*.log; do
    [ -f "$log_file" ] || continue      # skip if no .log files exist

    base=$(basename "$log_file" .log)   # Extract filename without extension e.g. heart_rate
    dest="archived_logs/${base}_${TIMESTAMP}.log"   # Build destination path with timestamp

    echo "Archiving: $log_file → $dest"
    mv "$log_file" "$dest"    #Move the log to archived_logs with new timestamped name

    
    # Recreate empty log so Python engine can continue writing
    touch "$log_file"
    echo "Recreated empty: $log_file"
done

echo ""
echo "✅ Log rotation complete — $(date)"
