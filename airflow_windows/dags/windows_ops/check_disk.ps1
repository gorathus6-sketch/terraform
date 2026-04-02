param(
    [Parameters(Mandatory=$true)]
    [int]$Threshold
)

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "$timestamp - $Message"
}

try {
    Write-Log "Starting disk usage check..."

    # Query C: Drive
    $disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"

    if (-not $disk) {
        Write-Log "ERROR: Unable to retrieve disk information for C:."
        exit 1
    }

    $usedPct = [math]::Round((($disk.Size - $disk.FreeSpace) / $disk.Size) * 100, 2)

    Write-Log "Disk C: usage is at $usedPct% (threshold: $Threshold%)"

    if ($usedPct -gt $Threshold) {
        Write-Log "WARNING: Disk usage exceeds threshold."
        exit 2
    }

    Write-Log "Disk usage is within acceptable limits."
    exit 0

} catch {
    Write-Log "ERROR: $($_.Exception.Message)"
    exit 1
}