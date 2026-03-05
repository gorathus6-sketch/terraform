param environment string = 'dev'
param location string = 'eastus'
param sku string = 'Standard_LRS'

var rgName = 'rg-empathome-core-${environment}'
var saName = 'stempathome${uniqueString(environment)}'

resource sa 'Microsoft.Storage/storage/Accounts@2024-02-02' = {
    name: saName
    location: location
    resourceGroup: rgName
    sku: {
        name: sku
    }
    kind: 'StorageV2'
    properties: {
        accessTier: 'Hot'
    }
}

resource saDiag 'Microsoft.Insights/diagnosticSettings@2022-05-01-preview' = {
    name: 'sa-diag'
    scope: sa
    properties: {
        workspaceId: logAnalyticsId
        logs: [
            {
                category: 'StorageRead'
                enabled: true
            }
            {
                category: 'StorageWrite'
                enabled: true
            }
            {
                category: 'StorageDelete'
                enabled: true
            }
            {
                category: 'Transaction'
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

output storageAccountName string = sa.name
output storageAccountId string = sa.id
