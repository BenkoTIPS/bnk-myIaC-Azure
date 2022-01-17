param appName string
param envName string
param favoriteColor string

@secure()
param mySecret string

var prefix = '${envName}-${appName}'
var webSiteName_var = '${prefix}-site'
var hostingPlanName_var = '${prefix}-plan'
var insightsName_var = '${prefix}-ai'

resource hostingPlanName 'Microsoft.Web/serverfarms@2015-08-01' = {
  name: hostingPlanName_var
  location: resourceGroup().location
  kind: 'linux'
  tags: {
    displayName: 'HostingPlan'
  }
  sku: {
    name: 'S1'
    tier: 'Standard'
  }
  properties: {
    name: hostingPlanName_var
    reserved: true
  }
}

resource webSiteName 'Microsoft.Web/sites@2015-08-01' = {
  name: webSiteName_var
  location: resourceGroup().location
  kind: 'app,linux'
  tags: {
    'hidden-related:${resourceGroup().id}/providers/Microsoft.Web/serverfarms/${hostingPlanName_var}': 'Resource'
    displayName: 'Website'
  }
  properties: {
    name: webSiteName_var
    serverFarmId: hostingPlanName.id
  }
}

resource webSiteName_appsettings 'Microsoft.Web/sites/config@2015-08-01' = {
  parent: webSiteName
  name: 'appsettings'
  location: 'centralus'
  tags: {
    displayName: 'config'
  }
  properties: {
    EnvName: envName
    FavoriteColor: favoriteColor
    MySecret: mySecret
    APPINSIGHTS_INSTRUMENTATIONKEY: insightsName.properties.InstrumentationKey
  }
}

resource insightsName 'Microsoft.Insights/components@2020-02-02' = {
  name: insightsName_var
  location: 'East US'
  kind: 'web'
  tags: {
    'hidden-link:${resourceGroup().id}/providers/Microsoft.Web/sites/${webSiteName_var}': 'Resource'
    displayName: 'AppInsightsComponent'
  }

  dependsOn: [
    webSiteName
  ]
}
