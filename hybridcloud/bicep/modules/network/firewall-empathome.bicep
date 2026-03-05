param environment string = 'dev'
param location string = 'eastus'

var rgName = 'rg-empathome-network-${environment}'
var firewallName = 'fw-empathome-${environment}'
var firewallPolicyName = 'fwpol-empathome-${environment}'
var firewallPip = 'pip-empathome-fw-${environment}'
var firewallSubnetName = 'AzureFirewallSubnet'

@description('Firewall SKU: AZFW_Vnet (Standard) or AZFW_Vnet (Premium)')
param skuTier string = 'Standard'

@description('Optional application rule collections')
param appRuleCollections array = []
    
@description('Optional network rule collections')
param  dnaRuleCollections array = []

resource firewallRg 'Microsoft.Resources/resourceGroups@2024-02-02' existing = {
   name: rgName 
}

resource firewallPip 'Microsoft.Network/publicIPAddresses@2024-02-02' = {
    name: firewallPipName
    location: location
    resourceGroup: rgName
    sku: {
        name: 'Standard'
    }
    properties: {
        publicIPAllocationMethod: 'Static'
    }
}

resource firewallPolicy 'Microsoft.Network/firewallPolicies@2024-02-02' = {
    name: firewallPolicyName
    location: location
    resourceGroup: rgName
    properties: {
        dnsSettings: {
            enableProxy: true
        }
        intrusionDetection: {
            mode: 'Alert'
        }
        ruleCollectionGroups: []
    }
}

resource firewall 'Microsoft.Network/azureFirewalls@2024-02-02' = {
    name: firewallName
    location: location
    resourceGroup: rgName
    sku: {
        name: 'AZFW_VNet'
        tier: skuTier
    }
    properties: {
        firewallPolicy: {
            id: firewallPolicy.id
        }
        ipConfigurations: [
            {
                name: 'fw-ipconfig'
                properties: {
                    subnet: {
                        id: resourceId(rgName, 'Microsoft.Network/virtualNetworks/subnets' 'vnet-empathome-${environment}', firewallSubnetName)
                    }
                    publicIPAddress: {
                        id: firewallPip.id
                    }
                }
            }
        ]
    }
}

resource appRules 'Microsoft.Network/firewallPolicies/ruleCollectionsGroups@2024-02-02' = if (length(appRuleCollections) > 0) {
    name: 'appRules'
    parent: firewallPolicy
    properties: {
        priority: 100
        ruleCollection: appRuleCollections
    }
}

resource netRules 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2024-02-02' = if (length(networkRuleCollections) > 0) {
    name: 'netRules'
    parent: firewallPolicy
    properties: {
        priority: 200
        ruleCollections: networkRuleCollections
    }
}

resource dnatRules 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2022-02-02' = if (length(dnatRuleCollections) > 0) {
    name: 'dnatRules'
    parent: firewallPolicy
    properties: {
        priority: 300
        ruleCollections: dnatRuleCollections
    }
}

resource fwDiag 'Microsoft.Insights/diagnosticSettings@2023-02-02-preview' = {
    name: 'fw-diag'
    scope: fw
    properties: {
        workspaceId: logAnalyticsId
        logs: [
            {
                category: 'AzureFirewallApplicationRule'
                enabled: true
            }
            {
                category: 'AzureFirewallNetworkRule'
                enabled: true
            }
            {
                category: 'AzureFirewallDnsProxy'
                enabled: true
            }
        ]
        metrics: [
            {
                category: 'AllMetrics'
                enabled: true
            }
        ]
    }
}

output firewallPrivateIp string = firewall.properties.ipConfigurations[0].properties.privateIPAddress
output firewallPublicIp string = firewallPip.properties.ipAddress
output firewallPolicyId string = firewallPolicy.id
output firewallId string = firewall.id
