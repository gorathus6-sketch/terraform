param location string
param namePrefix string
param tenantId string

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

module logAnalytics './loganalytics.bicep' = {
    name: 'logAnalytics'
    params: {
        location: location
        namePrefix: namePrefix
    }    
}

module keyVault './keyvault.bicep' = {
    name: 'keyVault'
    params: {
        location: location
        namePrefix: namePrefix
        tenantId: tenantId
        logAnalyticsId: logAnalytics.outputs.logAnalyticsId
        vnetId: vnet.outputs.vnetId
        subnetId: snet.outputs.subnetId // secure access subnet
    }
}

module uami './managedIdentity.bicep' = {
    name: 'deployIdentity'
    param: {
        location: location
        namePrefix: namePrefix
    }
}

// RBAC: Contributor for resourceGroup
module rbacRg '/.rbac-roleAssignments.bicep' = {
    name: 'rbac-rg-contributor'
    params: {
        principalId: uami.outputs.principalId
        scope: resourceGroup().id
        roleDefinitionId: subscriptionResourceId(
            'Microsoft.Authorization/roleDefiniations',
            'b24988ac-6180-42a0-ab88-20f7382dd24c' // contributor
        )
        nameSeed: 'rg-contributor'
    }
}


// RBAC key vault secrets
module rbacKv './rbac-roleAssignments.bicep' = {
    name: 'rbac-kv-secrets-officer'
    params: {
        principalId: uami.outputs.principalId
        scope: keyVault.outputs.keyVaultId
        roleDefinitionId: subscriptionResourceId(
            'Microsoft.Authorization/roleDefinitions',
            'b86a8fe4-44ce-4948-aee5-eccb2c155cd7' // key vault secrets official
        )
        nameSeed: 'kv-secrets-officer'
    }
}
