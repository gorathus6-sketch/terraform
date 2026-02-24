param(
    [Parameter(Mandatory=$true)]
    [int]$Threshold,

    [string]$Drive = "C:"
)

$disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='$Drive'"

$usedPct = [math]::Round((($disk.Size - $disk.FreeSpace) / $disk.Size) * 100)

if ($usedPct -ge $Threshold) {
    Write-Output "ALERT: Disk usage exceeds threshold."
    exit 1
}

Write-Output "OK: Disk usage is within limits."
exit 0