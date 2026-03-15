<#
.SYNOPSIS
    Collects an inventory of Azure resources in a subscription or resource group.

.DESCRIPTION
    Enumerates VMs, NICs, NSGs, VNets, Subnets, Storage Accounts, Key Vaults,
    Public IPs, and App Services. Outputs structured JSON suitable for audits,
    security reviews, and operational reporting.

.PARAMETER SubscriptionId
    The Azure subscription ID to target.

.PARAMETER ResourceGroup
    Optional. Limits the inventory to a specific resource group.

.PARAMETER OutputPath
    Path to write the JSON output.

.PARAMETER LogPath
    Path to write the log file.

.EXAMPLE
    .\Get-AzResourceInventory.ps1 -SubscriptionId "xxxx-xxxx" -OutputPath c:\homedir\inventory.json
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$SubscriptionId,

    [string]$ResourceGroup,

    [string]$OutputPath = "c:\homedir\azure-inventory.json",

    [string]$LogPath = "c:\homedir\inventory.log"
)

#
# Logging
#
function Write-Log {
    param([string]$Message)
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    "$timestamp :: $Message" | Out-File -FilePath $LogPath -Append
}

Write-Log "Starting Azure resource inventory..."

#
# safe exec wrapper
#
function Invoke-Safe {
    param(
        [string]$Name,
        [scriptblock]$Block
    )

    try {
        Write-Log ("Running: {0}" -f $Name)
        & $Block
    }
    catch {
        Write-Log ("ERROR in {0}: {1}" -f $Name, $_)
        return $null
    }
}

#
# set context
#
Invoke-Safe -Name "Set-AzContext" -Block {
    Set-AzContext -SubscriptionId $SubscriptionId | Out-Null
}

#
# Resource Filters
#
$rgFilter = @{}
if ($ResourceGroup) {
    $rfFilter["ResourceGroupName"] = $ResourceGroup
    Wrote-Log ("Filtering inventory to resource group: {0}" -f $ResourceGroup)
}

#
# collect resources
#
$vms = Invoke-Safe -Name "Get-AzVM" -Block {
    Get-AzVM @rgFilter | Select-Object Name, ResourceGroupName, Location, VmSize, ProvisioningState
}

$nics = Invoke-Safe -Name "GetAzNetworkInterface" -Block {
    Get-AzNetworkInterface @rgFilter | Select-Object Name, ResourceGroupName, IpConfigurations
}

$nsgs = Invoke-Safe -Name "Get-AzNetworkSecurityGroup" -Block {
    Get-AzNetworkSecurityGroup @rgFilter | Select-Object Name, ResourceGroupName, SecurityRules
}

$vnets = Invoke-Safe -Name "Get-AzVirtualNetwork" -Block {
    Get-AzVirtualNetwork @rgFilter | Select-Object Name, ResourceGroupName, AddressSpace, Subnets
}

$storage = Invoke-Safe -Name "Get-AzStorageAccount" -Block {
    Get-AzStorageAccount @rgFilter | Select-Object StorageAccountName, ResourceGroupName, Location, Sku
}

$keyvaults = Invoke-Safe -Name "Get-AzKeyVault" -Block {
    Get-AzKeyVault @rgFilter | Select-Object VaultName, ResourceGroupName, Location, EnabledForDeployment, EnabledForTemplateDeployment 
}

$publicIps = Invoke-Safe -Name "GetAzPublicIpAddress" -Block {
    Get-AzPublicIpAddress @rgFilter | Select-Object Name, ResourceGroupName, IpAddress, PublicIpAllocationMethod 
}

$appServices = Invoke-Safe -Name "Get-AzWebApp" - Block {
    Get-AzWebApp @rgFilter | Select-Object Name, ResourceGroup, Location, State, DefaultHostName
}

#
# Build Output Object
#
$inventory = [ordered]@{
    Timestamp = (Get-Date)
    Subscription = $SubscriptionId
    ResourceGroup = $ResourceGroup
    VirtualMachines = $vms
    NetworkInterfaces = $nics
    NetworkSecurityGroups = $nsgs
    VirtualNetworks = $vnets
    StorageAccounts = $storage
    KeyVaults = $keyvaults
    PublicIPAddresses = $publicIps
    AppServices = $appServices
}

#
# write output
#
try {
    $inventory | ConvertTo-Json -Depth 8 | Out-File $OutputPath
    Write-Log ("Inventory written to {0}" -f $OutputPath)
}
catch {
    Write-Log ("ERROR writing output: {0}" -f $_)
    exit 2
}

Write-Log "Azure resource inventory completed with success."
exit 0