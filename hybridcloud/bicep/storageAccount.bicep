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

output storageAccountName string = sa.name
output storageAccountId string = sa.id