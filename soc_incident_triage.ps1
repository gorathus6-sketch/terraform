# incident triage: this script collects evidence
# purpose: ID sus changes from prev. 24 hrs

$TimeLimit = (Get-Date).AddDays(-1)

# 1) ID sensitive files modified
Write-Host Scanning for recently modified files in Temp and AppData... -ForegroundColor Cyan
$SuspiciousFiles = GetChildItem -Path $env:TEMP, $env:AppData -Recurse -ErrorAction SilentlyContinue |
    Where-Object { $_.LastWriteTime -gt $TimeLimit } |
    Select-Object FullName, LastWriteTime, Length

# 2) chk registry run keys for new persistence
Write-Host Checking Registry Persistence... -ForegroundColor Cyan
$RunKeys = Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run'
# compare these results with a known, good baseline

# 3) List Network Connections to unusual ports
Write-Host Auditing Active Network Connections... -ForegroundColor Cyan
$NetConns = Get-NetTCPConnection |
    Where-Object { $_.State -eq 'Established' -and $_.RemotePort -notin 80, 443, 53 } |
    select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, OwningProcess

# 4) export findings analysis
$SuspiciousFiles | Export-Csv -Path .\Triage_Files.csv -NoTypeInformation $NetConns | Export-Csv -Path .\Triage_Network.csv -NoTypeInformation
$NetConns | Export-Csv -Path .\Triage_Network.csv -NoTypeInformation

Write-Host Triage Complete. Data exported to CSV. -ForegroundColor Green