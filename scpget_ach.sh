#!/bin/bash

# 1) build date var
CURRENT_DAY=$(date +"%Y%m%d")
FILENAME="ach_${CURRENT_DAY}.csv"

echo "checking for file $FILENAME"

# 2) remote defs
REMOTE_USER="airflowftp"
REMOTE_HOST=192.168.103.44
REMOTE_PATH='C:\inetpub\wwwroot\ftp\achin\'
LOCAL_DEST='/opt/servicemix/ingestion/'

# 3) exec scp
scp -i ~/.ssh/airflowftp.pem "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/${FILENAME}" \ ${LOCAL_DEST}


if [ $ -ne 0 ]; then
    echo "SCP failed for file: $FILENAME"
    exit 1
fi

echo "Successfully transfered: $FILENAME"
exit 0
