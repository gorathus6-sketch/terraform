#!/bin/bash
set -euo pipefail

AMQ_HOME="/opt/vulnerability_matching/apache_activemq_5.17"
AMQ_BIN="${AMQ_HOME}/bin/activemq"
AMQ_PORT=61616
HEALTH_TIMEOUT=30

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $1"
}

check_health() {
    log "Checking ActiveMQ health on port ${AMQ_PORT} ... "

    local elapsed=0
    while ! nc -z localhost ${AMQ_PORT} >/dev/null 2>&1; do
        sleep 1
        elapsed=$((elapsed + 1))

        if [ $elapsed -ge $HEALTH_TIMEOUT ]; then
            log "ERROR: ActiveMQ did not become healthy within ${HEALTH_TIMEOUT} seconds."
            return 1
        fi
    done

    log "ActiveMQ is healthy and listening on port ${AMQ_PORT}."
    return 0
}

log "Starting weekly ActiveMQ refresh..."

log "Stopping ActiveMQ..."
if ! ${AMQ_BIN} stop; then
    log "ERROR: ActiveMQ stop failed"
    exit 1
fi

log "Waiting 5 minutes before restart..."
sleep 300

log "Starting ActiveMQ..."
if ! ${AMQ_BIN} start; then
    log "ERROR: ActiveMQ failed to start."
    exit 1
fi

log "Weekly ActiveMQ refresh completed successfully"

# make sure to make this executable:
#
# chmod 771 /opt/vulnerability_matching/apache_activemq_5.17/weekly_activemq_refresh.sh
