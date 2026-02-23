#!/bin/bash

# get current date
CURRENTDATE=$(date +%Y%m%d)

# define the specific filename
STMT_FILE=statement_$CURRENTDATE.txt

# source and target dirs
SPOOL_DIR=/p4848/spool
SFTP_STMT_DIR=/mnt/c/inetpub/wwwroot/sftp/stmt_reports

# full path
FULL_SOURCE=$SPOOL_DIR/$STMT_FILE

# perform the copy with a check
if [ -f $FULL_SOURCE ]
then
    scp $FULL_SOURCE $SFTP_STMT_DIR
    echo Success: $STMT_FILE has been sent to $SFTP_STMT_DIR
else
    echo Error: $STMT_FILE was not found in $SPOOL_DIR
    exit 1
fi 
