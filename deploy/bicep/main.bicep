param appName string 
param envName string
param common_tags object = {
  Environment: 'poc'
  CreatedBy: 'arm-deploy'
  Repo: '#{GITHUB_REPOSITORY}#'
  CreateDt: utcNow('MM-dd-yyyy hh:mm')
  CostCenter: 'BenkoTips-DEMOS'
  Commit: '#{SHORT_SHA}#'
}

targetScope = 'subscription'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${envName}-${appName}-bicep-rg'
  location: 'centralus'
  tags: common_tags
}

module web 'website.bicep' = {
  scope: resourceGroup(rg.name)
  name: 'website.bicep'
  params: {
    appName: appName
    envName: envName
    favoriteColor: 'lightblue'
    mySecret: 'secret'
  }
}
