az login

az account show

$env = "bnk"
$appName = "iac-tf-azcli"
$rg = "$env-$appName-rg"
$params = ".\params.$env.json"
$deployName = "test-bicep-" + (get-date -format "MMdd-HHmm")

terraform init 

terraform plan -var-file params.bnk.tfvars

terraform apply -var-file params.bnk.tfvars

terraform destroy -var-file params.bnk.tfvars