$output = sqlplus -S user/passwd@DB @check_long_running.sql

if ($output -match "ORA-") {
    Write-Output "Database error detected"
    exit
}

if ($output -match "LONG_RUNNING") {
    Write-Output "Long running queries found"
    exit 1
}

Write-Output "Database healthy"
exit 0