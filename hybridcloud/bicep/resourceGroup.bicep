param environment string = 'dev'
param location string = 'eastus'
param tags object = {
    project: 'empathome'
    environment: environment
}

var rgName = 'rg-empathome-core-${environment}'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
    name: rgName
    location: location
    tags: tags
}

output resourceGroupName string = rg.rgName
output resourceGroupId string = rg.id