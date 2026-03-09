Connect-AzAccount
Get-AzVM | Select Name, ResourceGroupName, Location | Export-Csv vm_inventory.csv 