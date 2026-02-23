#!/bin/bash

CURRENTDATE=$(date +%Y%m%d)

# define target file
SOURCE_FILE=ach_$CURRENTDATE.ach

# define path and file
SOURCE_DIR=/mnt/c/inetpub/wwwroot/sftp/achin
SOURCE_PATH=$SOURCE_DIR/$SOURCE_FILE

# Test the path
if [ -f $SOURCE_PATH ]
then
    scp $SOURCE_PATH /p4848/spool
    echo Success: $SOURCE_FILE moved!
else
    echo Error: $SOURCE_FILE was not found in $SOURCE_DIR
    exit 1
fi
