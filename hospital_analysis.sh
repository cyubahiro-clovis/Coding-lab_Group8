#!/bin/bash

# Member 5: Clinical Analyst
process_vitals() {
    echo "=== Processing Critical Vitals ==="

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
    echo "=== Water Usage Audit ==="

    awk '
        $2 == "ICU_WATER_RESERVE" {
            total += $3
            count++
        }
        END {
            if (count > 0) {
                printf "%-25s %d readings\n", "ICU_WATER_RESERVE:", count
                printf "%-25s %.2f liters\n", "Average Usage:", total/count
            }
        }
    ' active_logs/water_usage.log
}

process_vitals
water_audit
