#!/bin/bash

# Member 5: Clinical Analyst
process_vitals() {
    echo "=== Processing Critical Vitals ==="

    # Check if log files exist before processing
    if [ ! -f "active_logs/heart_rate.log" ] || [ ! -f "active_logs/temperature.log" ]; then
        echo "ERROR: Log files not found. Is hospital_system.py running?"
        return 1
    fi

    # Clear the file first (fresh run)
    > reports/critical_alerts.txt

    echo "--- Heart Rate Critical Alerts ---" >> reports/critical_alerts.txt
    grep "CRITICAL" active_logs/heart_rate.log | \
        awk '{print $1, $2, $3}' >> reports/critical_alerts.txt

    echo "--- Temperature Critical Alerts ---" >> reports/critical_alerts.txt
    grep "CRITICAL" active_logs/temperature.log | \
        awk '{print $1, $2, $3}' >> reports/critical_alerts.txt

    echo "Critical alerts saved to reports/critical_alerts.txt"
}

# Member 6: Facility Auditor
water_audit() {
    echo ""
    echo "===================================="
    echo "     ICU WATER USAGE AUDIT REPORT   "
    echo "     Date: $(date)"
    echo "===================================="

    FILE="active_logs/water_usage.log"

    if [ ! -f "$FILE" ]; then
        echo "ERROR: Water usage log not found. Is hospital_system.py running?"
        return 1
    fi

    if [ ! -s "$FILE" ]; then
        echo "ERROR: Water usage log is empty."
        return 1
    fi

    awk '
        $2 == "ICU_WATER_RESERVE" {
            total += $3
            count++
        }
        END {
            if (count > 0) {
                printf "\n%-25s %d readings\n", "ICU_WATER_RESERVE:", count
                printf "%-25s %.2f liters\n\n", "Average Usage:", total/count
            } else {
                print "No ICU_WATER_RESERVE data found."
            }
        }
    ' "$FILE"

    echo "===================================="
    echo "Report generated successfully"
    echo "===================================="
}

process_vitals
water_audit
