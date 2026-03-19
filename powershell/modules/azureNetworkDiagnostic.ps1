Import-Module Az.Network

$vnets = GetAzVirtualNetworks
foreach ($vnet in $vnets) {
    foreach ($subnet in $vnet.Subnets) {
        $routes = Get-AzEffectiveRouteTable -NetworkInterfaceName $subnet.Name -ResourceGroupName $vnet.ResourceGroupName
        $nsg = Get-AzNetworkSecurityGroup -Name $subnet.NetworkSecurityGroup.Id.split('/')[-1]
        Write-Output "Subnet: $($subnet.Name)"
        Write-Output "Routes: $($routes.Count)"
        Write-Output "NSG Rules: $($nsg.SecurityRules.Count)"     
    }
}


#
# checks for NSG conflicts, effective rotutes,
# subnet health
#