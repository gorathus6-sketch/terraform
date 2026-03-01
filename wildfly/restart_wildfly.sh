#!/bin/bash
# restart_wildfly.sh
# safely restart wildfly 20 for weekly maintenance

SERVICE_NAME="wildfly"

echo "[$(date)] Starting Wildfly maintenance restart..."

# stop service
systemctl stop $SERVICE_NAME
if [ $? 0 ]; then
    echo "[$(date)] Error: Failed to stop Wildfly."
    exit 1
fi

# Optional: wait for ports to clear
sleep 5

# Start service
systemctl start $SERVICE_NAME
if [ $? -ne 0 ]; then
    echo "[$(date)] ERROR: Failed to start Wildfly."
    exit 1
fi

echo "[$(date)] Wildfly restart completed successfully."
exit 0
