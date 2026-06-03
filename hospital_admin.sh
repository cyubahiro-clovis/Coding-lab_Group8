#!/bin/bash 





source ./initialize_system.sh
source ./secure_data.sh

echo "Step 1: Initializing System..."
initialize_system

echo ""
echo "Step 2: Securing Data..."
secure_data

echo ""
echo "========================================="
echo " System Environment Secured"
echo " Date: $(date)"
echo "========================================="
# Third commit



