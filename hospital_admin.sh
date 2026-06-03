#!/bin/bash

# hospital_admin.sh
# Member 2 (Security Lead): secure_data()

secure_data() {
    echo "Securing the active_logs directory..."

    # Owner gets read + write + enter (x is needed to access a directory).
    # Group and others get nothing.
    chmod 700 active_logs

    echo "New permissions:"
    ls -ld active_logs
}
