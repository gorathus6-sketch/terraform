param(
    [Parameter(Mandatory=$true)]
    [int]$Threshold
)

Write-Output "$(Get-Date) - Starting disk usage check..."

# run df and output findings
$dfOutput = df -P / | Select-Object -skip 1

if (-not $dfOutput) {
    Write-Output "$(Get-Date) - ERROR: df return returned no data."
    exit 1
}

# split on whitespace
$parts = $dfOutput -split "\s+"

if ($parts.Count -lt 5) {
    Write-Output "$(Get-Date) - Error: Unexpected df output format: $dfOutput"
    exit 1
}

$usePctString = $parts[4]    # eg. "85%"

if (-not $usePctString.EndsWith("%")) {
    Write-Output "$(Get-Date) - ERROR: Could not parse disk usage percentage: $usePctString."
    exit 1
}

$usePct = $usePctString.TrimEnd('%') -as [int]

if ($usePct -eq $null) {
    Write-Output "$(Get-Date) - ERROR: Disk usage percentage is null."
    exit 1
}

Write-Output "$(Get-Date) - Disk usage: $usePct%"

if ($usePct -ge $Threshold) {
    Write-Output "$(Get-Date) - ERROR: Disk usage above threshold ($Threshhold%)"
    exit 1
}

Write-Output "$(Get-Date) - Disk usage is healthy."
exit 0
