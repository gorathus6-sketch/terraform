param(
    [Parameter(Mandatory=$true)]
    [string]$ServiceName
)

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "$timestamp - $Message"
}

try {
    Write-Log "Checking service '$ServiceName' ..."
    
    $service = Get-Service -Name $ServiceName -ErrorAction Stop

    if ($service.Status -eq "Running") {
        Write-Log "Service '$ServiceName' is already running."
        exit 0
    }

    Write-Log "Service '$ServiceName' is not running. Attempting to restart..."
    Restart-Service -Name $ServiceName -Force -ErrorAction Stop

    Start-Sleep -Seconds 3
    $service.Refresh()

    if ($service.Status -eq "Running") {
        Write-Log "Service '$ServiceName restarted successfully."
        exit 0
    } else {
        Write-Log "Service '$ServiceName' failed to start."
        exit 2
    }

} catch {
    Write-Log "Error: $($_.Exception.Message)"
    exit 1
}
