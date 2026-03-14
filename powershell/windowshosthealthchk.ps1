param(
    [string]$OutputPath = "c:\homedir\health.json"
)

$health = [ordered]@{
    Timestamp = (GetDate)
    CPU       = (GetCounter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
    Memory    = (GetCounter '\Memory\Available MBytes').CounterSamples.CookedValue
    Disk      = Get-PSDrive -PSProvider FileSystem | Select-Object Name, Free, Used
    Services  = Get-Service | Where-Object {$_.Status -ne "Running"} | Select Name, Status
}

$health | ConvertTo-Json -Depth 4 | Out-File $OutputPath

if ($health.Services.Count -gt 0) {
    exit 1
} else {
    exit 0
}
