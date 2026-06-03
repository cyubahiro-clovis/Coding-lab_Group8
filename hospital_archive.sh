#!/bin/bash

# ====================================================================
# Script: hospital_archive.sh
# Author: Ryan Prince Gakire
# Role: Member 4 - The Archivist
# Purpose: Rotates logs from active_logs to archived_logs with timestamps
# ====================================================================

# Verify that active_logs directory exists before proceeding
if [ ! -d "active_logs" ]; then
    echo "❌ Error: active_logs directory not found. Run hospital_admin.sh first."
    exit 1
fi

# Verify that archived_logs directory exists before proceeding
if [ ! -d "archived_logs" ]; then
    echo "❌ Error: archived_logs directory not found. Run hospital_admin.sh first."
    exit 1
fi

echo "✅ Directories verified."


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
