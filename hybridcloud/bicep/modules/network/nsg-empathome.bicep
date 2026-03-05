param environment string = 'dev'
param location string = 'eastus'
param rgName string = 'rg-empathome-${environment}'
param nsgName string = 'nsg-empathome-${environment}-${uniqueString(environment)}'

@description('Inbound rules for the NSG')
param inboundRules array = [
    {
        name: 'Allow-HTTPS'
        priority: 100
        direction: 'Inbound'
        access: 'Allow'
        protocol: 'Tcp'
        sourcePortRange: '*'
        destinationPortRange: '443'
        sourceAddressPrefix: '*'
        destinationAddressPrefix: '*'
    }
]

resource nsg 'Microsoft.Network/networkSecurityGroups@2024-02-02' = {
    name: nsgName
    location: location
    resourceGroup: rgName
    properties: {
        securityRules: [for rule in inboundRules: {
            name: rule.name
            properties: {
                priority: rule.priority
                direction: rule.direction
                access: rule.access
                protocol: rule.protocol
                sourcePortRange: rule.sourcePortRange
                destinationPortRange: rule.destinationPortRange
                sourceAddressPrefix: rule.sourceAddressPrefix
                destinationAddressPrefix: rule.destinationAddressPrefix
            }
        }]
    }
}

resource nsgDiag 'Microsoft.Insights/diagnosticSettings@2023-02-02-preview' = {
    name: 'nsg-diag'
    scope: nsg
    properties: {
        workspaceId: logAnalyticsId
        logs: [
            {
                category: 'NetworkSecurityGroupEvent'
                enabled: true
            }
            {
                category: 'NetworkSecurityGroupRuleCounter'
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

output nsgId string = nsg.id
output nsgNameOut string = nsg.name
