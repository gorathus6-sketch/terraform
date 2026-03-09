$procs = Get-Process | Sort-Object CPU -Descending | Select-Object -First 10
$procs | ConvertTo-Json | Out-File "c:\homedir\process_spike.json"