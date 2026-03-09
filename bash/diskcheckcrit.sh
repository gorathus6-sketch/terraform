#!/bin/bash
set -e

THRESHOLD=85
FILESYSTEM='/'

# extract the numeric percentage (eg n from n%)
USAGE=$(df -h "$FILESYSTEM" | awk 'NR==2 {gsub("%","",$5); print $5}')

echo "Disk usage on $FILESYSTEM is ${USAGE}% (threshold: ${THRESHOLD}%)"

if [ "$USAGE" -gt "$THRESHOLD" ]; then
    echo "ERROR: Disk usage is critical, rectify immediately!"
    exit 1
else
    echo "Disk usage within acceptable limits."
    exit 0
fi
