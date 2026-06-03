#!/bin/bash

secure_data() {
    echo "Securing the active_logs directory"

    chmod 700 active_logs

    echo "New permissions:"
    ls -ld active_logs
}
