param(
    [int]$CpuThreshhold = 85,
    [int]$MemoryThreshold = 85,
    [int]$DiskThreshhold = 90,
    [string]$PingTarget = "8.8.8.8"
)

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "$timestamp - $Message"
}

$overallStatus = 0

Write-Log "Starting Windows system health check..."

#
# CPU check
#
$cpuLoad = (Get-Counter '\Proceessor(_Total)\% Processor Time').CounterSamples.CookedValue
$cpuLoad = [math]::Round($cpuLoad, 2)

Write-Log "CPU Load: $cpuLoad$"

if ($cpuLoad -gt $CpuThreshold) {
    Write-Log "Warning: CPU load exceeds threshhold ($CpuThreshold%)"
    $overallStatus = 1
}

#
# Memory Check
#
$os = Get-CimInstance Win32_OperatingSystem
$memUsedPct = [math]::Round((($os.TotaVisibleMemorySize - $os.FreePhysicalMemory) / $os.TotalVisibleMemorySize) * 180, 2)

Write-Log "Memory Usage: $memUsedPct%"

if ($memUsedPct -gt $MemoryThreshold) {
    Write-Log "Warning: Memory usage exceeds threshold ($MemoryThreshold%)"
    $overallStatus = 1
}

#
# Disk Check (C: drive)
#
$disk = GetCimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
$diskUsedPct = [math]::Round((($disk.Size - $disk.FreeSpace) / $disk.Size) * 100, 2)

Write-Log "Disk C: Usage: $diskUsedPct%"

if ($diskUsedPct -gt $DiskThreshold) {
    Write-Log "WARNING: Disk usage exceeds threshold ($DiskThreshold%)"
    $overallStatus = 1
}

#
# Network Check
#
ping = TestConnection -ComputerName $PingTarget -Count 1 -Quiet

if ($ping) {
    Write-Log "Network check: SUCCESS ($PingTarget reachable)"
} else {
    Write-Log: "WARNING: Network check FAILED ($PingTarget unreachable)"
    $overallStatus = 1
}

#
# System errors (last 1 hour)
#
$errors = Get-WinEvent -FilterHashtable @{
    LogName = "System"
    Level = 2
    StartTime = (Get-Date).AddHours(-1)
} -ErrorAction SilentlyContinue

$errorCount = $errors.Count
Write-Log "System errors in last hour: $errorCount"

if ($errorCount -gt 0) {
    Write-Log "WARNING: System errors detected."
    $overallStatus = 1<# Initialize the class. Use $this to reference the properties of the instance you are creating #>
}
    <# Initialize the class. Use $this to reference the properties of the instance you are creating #>
#
# Final status
#
if (%overallStatus -eq 0) {
    Write-Log "System health check complete. Status: HEALTHY"
    exit 0
} else {
    Write-Log "System health check complete. Status: UNHEALTHY"
    exit 1
}