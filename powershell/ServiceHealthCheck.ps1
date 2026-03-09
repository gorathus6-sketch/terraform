$services = Get-Service | Where-Object {$_.Status -ne "Running"}
$services | ConvertTo-Json | Out-File "c:\homedir\service_health.json"