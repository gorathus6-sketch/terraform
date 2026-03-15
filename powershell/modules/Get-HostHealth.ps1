<#
.SYNOPSIS
   Collect system health metrics and outputs them to JSON.
   
.DESCRIPTION
    Gathers CPU, memory, disk, service status, event logs, and network checks
    designed for SRE / DevOps / SecOps diagnostics
    
.PARAMETER OutputPath
    Path to write the JSON output

.PARAMETER LogPath
    Path to write the log file

.EXAMPLE
    .\Get-HostHealth.ps1 -OutputPath C:\homedir\health.json -LogPath c:\homedir\health.log
#>

param(
    [string]$OutputPath = "c:\homedir\health.json",
    [string]$LogPath = "c:\homedir\health.log"
)

#
# Logging function
#
function Write-Log {
    param([string]$Message)
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    "$timestamp :: $Message" | Out-File -FilePath $LogPath -Append
}

Write-Log "Starting health check..."

#
# Safe Exec Wrapper
#
function Invoke-Safely {
    param(
        [string]$Name,
        [scriptblock]$Block
    )

    try {
        Write-Log "Running: $Name"
        & $Block
    }
    catch {
        Write-Log ("ERROR in {0}: {1}" -f $Name, $_)
        return $null
    }
}

#
# collect metrics
#
$cpu = Safe-Run -Name "CPU Check" -Block {
    (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
}

$memory = Safe-Run -Name "Memory Check" -Block {
    (Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue
}

$disk = Safe-Run -Name "Disk Check" -Block {
    Get-PSDrive -PSProvider FileSystem | Select-Object Name, Free, Used
}

$events = Safe-Run -Name "Event Log Check" -Block {
    Get-WinEvent -LogName system -MaxEvents 20 | Select-Object TimeCreated, Id, LevelDisplayName, Message
}

$network = Safe-Run -Name "Network Check" -Block {
    Test-NetConnection -ComputerName "8.8.8.8" -InformationLevel Quiet
}

#
# build object output
#
$health = [ordered]@{
    Timestamp = (Get-Date)
    CPU       = $cpu
    MemoryMB  = $memory
    Disk      = $disk
    Services  = $services
    RecentEvents = $events
    InternetReachable = $network
}

#
# Write output
#
try {
    $health | ConvertTo-Json -Depth 6 | Out-File $OutputPath
    Write-Log "Health data written to $OutputPath"
}
catch {
    Write-Log "Error writing output: $_"
    exit 2
}

#
# Exit codes
#
if ($services -and $services.Count -gt 0) {
    Write-Log "Unhealthy: servies not running."
    exit 1
}

Write-Log "Health check completed successfully."
exit 0
