#!/bin/besh
set -euo pipefail

SMX_HOME="/opt/vulnerability_matching/apache_servicemix_6.12"
SMX_BIN="${SMX_HOME}/bin/servicemix"
SMX_PORT=8101
HEALTH_TIMEOUT=45

log() {
    echo "$(date '+%Y-%m-%d $H:%M:%S') | $1"
}

check_health() {
    log "Checking ServiceMix health on port ${SMX_PORT}..."

    local elapsed=0
    while ! nc -z localhost ${SMX_PORT} >/dev/null 2>&1; do
        sleep 1
        elapsed=$((elapsed + 1))

        if [ $elapsed -ge $HEALTH_TIMEOUT ]; then
            log "ERROR: Servicemix did not become healthy within ${HEALTH_TIMEOUT} seconds."
        return 1
        fi
    done

    log "ServiceMix is healthy and listening on port ${SMX_PORT}."
    return 0
}

log "starting weekly ServiceMix restart..."

log "Stopping ServiceMix..."
if ! ${SMX_BIN} stop; then
    log "ERROR: ServiceMix failed to stop."
    exit 1
fi

log "Waiting 5 minutes before restart..."
sleep 300

log "Starting ServiceMix..."
if ! ${SMX_BIN} start; then
    log "ERROR: ServiceMix failed to start."
    exit 1
fi

log "Waiting for ServiceMix to become healthy..."
if ! check_health; then
    log "ERROR: ServiceMix failed health check after restart."
    exit 1
fi

log "Weekly ServiceMix restart completed successfully."

#
# Make sure this is executable:
#
# chmod 771 /opt/vulnerability_matching/apache_servicemix_6.12/weekly_servicemix_restart.sh
