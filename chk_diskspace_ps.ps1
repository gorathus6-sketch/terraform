param(
    [int]$Threshold = 75,
    [string]$Drive = "C:"
)

# Get disk usage percentage
$usage = (Get-PSDrive -Name $Drive).Used / (Get-PSDrive -Name $Drive).Capacity * 100
$usage = [math]::Round($usage, 2)

Write-Output "Disk usage on $Drive is $usage% (threshold: $Threshold%)"

if ($usage -gt $Threshold) {
    Write-Error "ERROR: Disk usage exceeded threshold."
    exit 1
} else {
    Write-Output "OK: Disk usage is within limits."
    exit
}