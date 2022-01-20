az login

az account show

$env = "bnk"
$appName = "iac-tf-azcli"
$rg = "$env-$appName-rg"
$params = ".\params.$env.json"
$deployName = "test-bicep-" + (get-date -format "MMdd-HHmm")

del .\.terraform*
terraform init -backend-config="local.backend.tfvars"

terraform plan -var-file params.bnk.tfvars

terraform apply -var-file params.bnk.tfvars

terraform destroy -var-file params.bnk.tfvars