<#
.SYNOPSIS
    Performs a system health check including disk usage, service status, network connectivity, and event log errors.

.DESCRIPTION
    This script is designed for operational environments. It checks:
    - Disk Usage for a given drive
    - Status of critical services
    - Network connectivity to a target host
    - Recent system errors in the event log

.PARAMETER Drive
    The drive letter to check (default: C:)

.PARAMETER Services
    A list of servics to verify are running.

.PARAMETER TargetHost
    A hostname or IP to test network connectivity.

.PARAMETER LogFile

.EXAMPLE
    .\SystemHealthCheck.ps1 -Services "wuauserv", "bits" -TargetHost "8.8.8.8"
#>

param(
    [string]$Drive = "C:",
    [string[]]$Services = @("wuauserv","bits"),
    [string]$TargetHost = "8.8.8.8",
    [string]$LogFile = ".\healthcheck.log"
)

Write-Log "Starting system health check..."

# ----------------
# Disk Usage Check
# ----------------
$disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='$Drive'"
$usedPct = [math]::Round((($disk.Size - $disk.FreeSpace) / $disk.Size) * 100)

Write-Log "Disk $Drive usage: $usedPct%"

if ($usedPct -gt 85) {
    Write-Log "Warning: Disk usage exceeds 85%"
}

# --------------
# Service Status
# --------------
foreach ($svc in $Services) {
    $service = Get-Service -Name $svc -Error Action SilentlyContinue
    if ($null -eq $service) {
        Write-Log "ERROR: Service '$svc' not found"
        continue
    }

    Write-Log "Service '$svc' status: $($service.Status)"

    if ($service.Status -ne "Running") {
        Write-Log "Attempting to start service '$svc'"
        try {
            Start-Service -Name $svc -ErrorAction Stop
            Write-Log "Service '$svc' started successfully"
        }
        catch {
            Write-Log "ERROR: Failed to start service '$svc' - $($_.Exception.Message)"
        }
    }
}

# --------------------------
# Network Connectivity Check
# --------------------------
$ping = Test-NetConnetion -ComputerName $TargetHost -WarningAction SilentlyContinue

if ($ping.PingSuccessed) {
    Write-Log "Network check: SUCCESS ($TargetHost reachable)"
} else {
    Write-Log "Network check: FAILED ($TargetHost unreachable)"
}

# ----------------
# Event Log Check
# ----------------
$errors = Get-WinEvent -LogName System -MaxEvents 20 |
          Where-Object { $_.LevelDisplayName -eq "Error" }

Write-Log "Recent system errors: $($errors.Count)"

Write-Log "System health check complete."
exit 0
