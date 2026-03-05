param location string
param namePrefix string

resource uami 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
    name: '${namePrefix}-uami-deploy'
    location: location
}

output principalId string = uami.properties.principalId
output identityId string = uami.id
