#!/bin/bash

# don't forget to chmod +x this file to make it executable

ORACLE_HOME=/opt/oracle/product/19c/dbhome_1
export ORACLE_HOME
export PATH=$ORACLE_HOME/bin:$PATH

DB_USER="monitor_user"
DB_PASS="your_password"
DB_TNS="ORCLPDB1"

SQL_FILE="/p4848/scheduler/longrunningquery_batch.sql"

OUTPUT=$(sqlplus -s "$DB_USER/$DB_PASS@$DB_TNS" <<EOF
@${SQL_FILE}
EOF
)

echo "$OUTPUT"

# Optional: fail if long-running queries exist
if echo "$OUTPUT" | grep -q "SECONDS_RUNNING"; then
    echo "LONG-running queries detected"
    exit 1
fi

exit 0
