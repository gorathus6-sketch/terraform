@description('Location for Log Analytics')
param location string

@description('Name prefix')
param namePrefix string

@minValue(30)
@maxValue(730)
param retentionInDays int = 90

resource law 'Microsoft.OperationalInsights/workspaces@2024-02-02' = {
    name: '${namePrefix}-law'
    location: location
    properties: {
        retentionInDays: retentionInDays
        features: {
            enableLogAccessUsingOnlyResourcePermissions: true
        }
    }
}

output logAnalyticsId string = law.id
