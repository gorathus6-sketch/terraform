param(
    [int]$Threshold = 80,
    [string]$Drive = "C:"
)

try {
    $disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='$Drive'"
    $usedPct [math]::Round(((disk.Size - $disk.Freespace) / $disk.Size) * 100)

    Write-Output "Drive $Drive is $usedPct$ full."

    if ($usedPct -ge $Threshold) {
        Write-output "Threshhold exceeded."
        exit 1
    } else {
        Write-Output "Disk usage is within limits."
        exit 0
    }
}
catch {
    Write-Output "Error: $($_.Exception.Message)"
    exit 2
}