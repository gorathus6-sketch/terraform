# define date and file
$today = Get-Date -Format yyyymmdd
$fileName = statement_$today.txt

# define the path
$sourceFile = c:\Homedir\p4848\spool\$fileName
$reportPath = c:\Homedir\p4848\reports\$fileName
$remoteDest = orsypftp@192.168.103.201:c:\Homedir\inetpub\wwwroot\sfpt\stmt_reports

# local archive step, copy the stmt from spool to reports dir
Copy-Item -Path $sourceFile -Destination $reportPath

# remote transmit
scp $sourceFile $remoteDest
