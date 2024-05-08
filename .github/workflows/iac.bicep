var rootName = 'GraceBomb'
var functionName = '${rootName}-function'
var location = resourceGroup().location

resource hostingPlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: '${rootName}-plan'
  location: location
  kind: 'linux'
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: {
    reserved: true
  }
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: '${rootName}-insights'
  location: location
  tags: {
    'hidden-link:${resourceId('Microsoft.Web/sites', functionName)}': 'Resource'
  }
  properties: {
    Application_Type: 'web'
  }
  kind: 'web'
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: '${toLower(rootName)}storage'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource functionApp 'Microsoft.Web/sites@2023-01-01' = {
  name: functionName
  location: location
  kind: 'functionapp,linux'
  properties: {
    serverFarmId: hostingPlan.id
    siteConfig: {
      linuxFxVersion: 'DOTNET-ISOLATED|8.0'
      appSettings: [
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: reference(resourceId('Microsoft.Insights/components', applicationInsights.name), '2020-02-02').ConnectionString
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(functionName)
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet-isolated'
        }
        {
          name: 'google_spreadsheet_id'
          value: '1CrShwKtsiXPvuwC6K_DRF63OYfR3p67SbVhGfqhadEo'
        }
        {
          name: 'google_credential'
          value: ''
        }
      ]
    }
  }
}
