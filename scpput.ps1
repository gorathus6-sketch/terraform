# Def variables
$CurrentDate = Get-Date -Format yyyyMMdd
$RemoteUser = orsypftp
$RemotePath = C:\inetpub\wwwroot\ftp\stmt_reports\
$FileName = statement_$CurrentDate.txt
$LocalDest = C:\p4848\spool

# Construct the pull local path
$LocalFile = Join-Path -Path $LocalDest -ChildPath $FileName

# exec SCP
# ATTN: ensure the .pem file is correct for the windows user
scp -i $env:USERPROFILE\.ssh\orsypftp.pem $LocalFile ${RemoteUser}@${RemoteHost}:${RemotePath}