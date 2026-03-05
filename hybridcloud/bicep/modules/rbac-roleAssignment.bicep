param principalId string
param scope string
param roleDefinitionId string

@description('Optional name seed to make the GUID stable')
param nameSeed string = 'default'

resource roleAssignment 'Microsoft.Authorization/roleAssignment@2023-04-01' = {
   name: guid(scope, principalId, roleDefinitionId, nameSeed)
   scope: scope
   properties: {
    principalId: principalId
    roleDefinitionId: roleDefinitionId
    principalType: 'ServicePrincipal'
   } 
}
