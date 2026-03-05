param environment string = 'dev'
param location string = 'eastus'
param addressSpace string = '10.10.0.0/16'

var vnetName = 'vnet-empathome-${environment}'
var rgName = 'rg-empathome-network-${environment}'

resource vnet 'Microsoft.Network/virtualNetworks@2024-02-02' = {
    name: vnetName
    location: location
    resourceGroupe: rgName
    properties: {
        addressSpace: {
            addressPrefixes: [
                addressSpace
            ]
        }
    }
}

output vnetName string = vnet.name
output vnetID string = vnet.id
