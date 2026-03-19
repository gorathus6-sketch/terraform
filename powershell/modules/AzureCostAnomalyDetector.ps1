Import-Module Az.CostManagement

$today = Get-Date
$yesterday = $today.AddDays(-1)

$costToday = Get-AzCostManagementQuery -Timeframe Custom -From $today -To $today
$costYesterday = Get-AzCostManagementQuery -Timeframe Custom -From $yesterday -To $yesterday

if ($costToday.Rows[0][0] -gt ($costYesterday.Rows[0][0] * 1.25)) {
    Write-Output "Cost anomaly detected!"
}

# use this to detect cost spikes