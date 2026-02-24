#!/usr/bin/env bash

# To run:

# nohup ./filecheck.sh /path/to/datafile.txt &

# File Validation Script

FILE="$1"
EXPECTED_DATE=$(date +"%Ym%d")   # or pass as $2 if needed
LOGFILE="./filecheck.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOGFILE"
}

if [ -z "$FILE" ]; then
    echo "Usage: $0 <datafile>"
    exit 99
fi

if [ ! -f "$FILE" ]; then
    log "ERROR: File not found: FILE"
    exit 1

log "Checking file: $FILE"

# Validate Header

header=$(head -n 1 "$FILE")

if [[ "$header" != *"$EXCPECTED_DATE"* ]]; then
    log "ERROR: Header does not contain expected date: $EXPECTED_DATE"
    log "Header was: $header"
    exit 2
fi

log "Header contains correct date: $EXPECTED_DATE"

# validate record count
# Count all lines expect header
record_count=$(tail -n +2 "$FILE" | wc -l)

if [ "$record_count" -eq 0 ]; then
    log "ERROR: No data records found in file"
    exit 3
fi

log "Record count OK: $record_count records found"

log "File validation successful."
exit 0


