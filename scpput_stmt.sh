#!/bin/bash

# def variables (windows)
CURRENT_DATE=$(date +%Y%m%d)
REMOTE_USER=orsypftp
REMOTE_HOST=192.168.103.44
REMOTE_PATH='C:\inetpub\wwwroot\ftp\stmt_reports\'
FILE_NAME=statement_${CURRENT_DATE}.txt
LOCAL_DEST=/p4848/spool/

scp -i ~/.ssh/orsypftp.pem ${LOCAL_DEST}/${FILE_NAME} ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_PATH} 