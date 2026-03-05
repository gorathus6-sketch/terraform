module nsg 'nsg-empathome.bicep' = {
    name: 'nsgModule'
    params: {
        environment: 'dev'
    }
}

module rt 'rt-empathome.bicep' = {
    name: 'rtModule'
    params: {
        environment: 'dev'
    }
}

module subnets 'subnets-empathome.bicep' = {
    name: 'subnetModule'
    params: {
        environment: 'dev'
        subnets: [
            {
                name: 'snet-apps'
                prefix: '10.10.1.0/24'
                nsgId: nsg.outputs.nsgId
                routeTableId: rt.outputs.routeTableId
            }
            {
                name: 'snet-db'
                prefix: '10.10.2.0/24'
                nsgId: nsg.outputs.nsgId
                routeTableId: rt.outputs.routeTableId
            }
        ]
    }
}
