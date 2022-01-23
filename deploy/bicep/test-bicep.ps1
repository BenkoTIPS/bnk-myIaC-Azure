az login

az account show

$rg = "bnk-iac-azure-bicep"

az group create --name $rg --location centralus

az deployment group create --resource-group $rg --template-file website.bicep

$templateFile = 'main.bicep'
$today = Get-Date -Format 'MM-dd-yyyy'
$deploymentName = "test-bicep-$today"

az deployment sub create --name $deploymentName --location centralus --template-file $templateFile --parameters appName=iac-cli
az group delete --name $rg
