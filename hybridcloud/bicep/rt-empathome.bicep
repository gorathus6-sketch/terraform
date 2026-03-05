param environment string = 'dev'
param location string = 'eastus'
param rgName string = 'rg-empathome-network-${environment}'
param routeTableName string = 'rt-empathome-${environment}'

@description('Custom routes for the route table')
param routes array = [
    {
        name: 'DefaultToFirewall'
        addressPrefix: '0.0.0.0/0'
        nextHopType: 'VirtualAppliance'
        nextHopIpAddress: '10.10.0.4'
    }
]

resource rt 'Microsoft.Network/routeTables@2024-02-02' = {
    name: routeTableName
    location: location
    resourceGroup: rgName
    properties: {
        routes: [for r in routes: {
            name: r.name
            properties: {
                addressPrefix: r.addressPrefix
                nextHopType: r.nextHopType
                nextHopIpAddress: r.nextHopIpAddress
            }
        }]
    }
}

output routeTableId string = rt.id
output routeTableNameOut string = rt.name
