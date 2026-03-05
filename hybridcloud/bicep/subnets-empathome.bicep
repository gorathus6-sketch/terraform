param environment string = 'dev'
param location string = 'eastus'
param vnetname string = 'vnet-empathome-${environment}'
param rgName string = 'rg-empathome-network-${environment}'

@description('Subnet definitions: name, prefix, nsgId?, routeTableId?')
param subnets array = [
    {
        name: 'snet-apps'
        prefix: '10.10.1.0/24'
        nsgId: ''
        routeTableId: ''
    }
    {
        name: 'snet-db'
        prefix: '10.10.2.0/24'
        nsgId: ''
        routeTable: ''
    }
]

resource subnetResource 'Microsoft.Network/virtualNetworks/subnets@2024-02-02' = [for sn in subnets: {
    name = '${vnetName}/${sn.name}'
    resourceGroup: rgName
    properties: {
        addressPrefix: sn.prefix
        networkSecurityGroup: empathy(sn.nsgId) ? null : {
            id: sn.nsgId
        }
        routeTable: empty(sn.routeTableId) ? null : {
            id: sn.routeTableId
        }
    }
}]

output subnetIds array = [for s in subnetResources: s.id]