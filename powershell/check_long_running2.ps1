#
# Oracle Database Health Check
#

# Path to SQLPlus (adjust if needed)
$sqlplusPath = "C:\oracle\product\19c\client_1\bin\sqlplus.exe"

# Credentials and DB alias
$connection = "user/password@DB"

# SQL script to run
$sqlScript = "@C:\scripts\check_long_running.sql"

# Run SQLPlus and capture output
$output = & $sqlplusPath -S $connection $sqlScript 2>&1

# Print raw output for logs (optional)
# Write-Output $output

# check for ORA errors
if ($output -match "ORA-") {
    Write-Output "Data base error detected:"
    Write-Output ($output | Select-String "ORA-")
    exit 1
}

# check for custom flags from the sql script
# eg: your SQL script prints 'LONG_RUNNING' if queries exceed threshold
if ($output -match "LONG_RUNNING") {
    Write-Output "Long-running queries detected."
    exit 1
}

# if we reach here, DB is healthy
Write-Output "Database is healthy."
exit 0