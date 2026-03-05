param location string
param namePrefix string
param tenantId string
param logAnalysticsId string
param vnetId string
param subnetId string

@allowed([
    'standard'
    'premium'
])
param skuName string = 'standard'

resource kv 'Microsoft.KeyVault/vaults@2023-02-01' = {
    name: '${namePrefix}-kv'
    location: location
    properties: {
        tenandId: tenantId
        sku: {
            family: 'A'
            name: skuName
        }
        enabledRbacAuthorization: true
        enabledForDeployment: false
        enabledForDiskEncryption: false
        enabledforTemplateDeployment: true
        networkAcls: {
            defaultAction: 'Deny'
            bypass: 'AzureServices'
            virtualNetworkRules: [
                {
                    id: subnetId
                }
            ]
            ipRules: []
        }
        publicNetworkAccess: 'Disabled'
    }
}

resource kvDiag 'Microsoft.Insights/diagnosticSettings@2023-05-01-preview' = {
    name: 'kv-diag'
    scope: kv
    properties: {
        workspaceId: logAnalysticsId
        logs: [
            {
                category: 'AuditEvent'
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

output keyVaultId string = kv.id
output keyVaultName string = kv.name
