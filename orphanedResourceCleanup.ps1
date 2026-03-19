Import-Module Az.Compute
Import-Module Az.Network

$disks = Get-AzDisk | Where-Object { $_.ManagedBy -eq $null }
$ips = Get-AzPublicIpAddress | Where-Object { $_.IpConfiguration -eq $null }
$nics = Get-AzNetworkInterface | Where-Object { $_.VirtualMachine -eq $null }

$report = [PSCustomObject]@{
    OrphanedDisks = $disks.Count
    OrphanedIPs = $ips.Count
    OrphanedNICs = $nics.Count
}

report | ConvertTo-Json | Out-File "orphaned_resources.json"

#
# use to find unattached disks, NICs, IPs,
# NSGs for keeping inventory organized
# and cost efficient