param([string]$TargetHost = "8.8.8.8", [int]$Port = 433)

$result = Test-NetConnection -ComputerName $TargetHost -Port $Port
$result | ConvertTo-Json | Out-File "c:\homedir\netdiag.json"