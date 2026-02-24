#!/usr/bin/env bash

# system health check script (bash)

DRIVE="/"
SERVICES=("ssh" "cron")
TARGET_HOST="8.8.8.8"
LOGFILE="./healthcheck.log"

log() {
    local msg="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $msg" | tee -a "$LOGFILE"
}

log "Starting system health check..."

# disk usage check

disk_used=$(df -h "$DRIVE" | awk 'NR==2 {print $5}' | td -d '%')
log "Disk $DRIVE usage: ${disk_used}%"

if [ "$disk_used" -gt 85 ]; then
    log "WARNING: Disk usage exceeds 85%"
fi

# service status check

for svc in "${SERVICES[@]}"; do
    if systemctl list-units --type=service | grep -q "$svc"; then
        status=$(systemctl is-active "$svc")
        log "Service '$svc' status: $status"
        
        if [ "$status" != "active" ]; then
            log "Attempting to start service '$svc'"
            if systemctlm start "$svc"; then
                log "Service '$svc' started successfully"
            else
                log "ERROR: Failed to start service '$svc'"
            fi
        fi
    else
        log "ERROR: Service '$service '$svc' not found"
    fi
done

# Network Connectivity Check

if ping -c 1 -W 2 "$TARGET_HOST" > /dev/null 2>&1; then
    log "Network check: SUCCESS ($TARGET_HOST reachable)"
else
    log "Network check: FAILED ($TARGET_HOST unreachable)"
fi

# Recent System errors

error_count=$(journalctl -p err -n 20 | wc -l)
log "Recent system errors: $error_count"

log "System health check complete."
exit 0
