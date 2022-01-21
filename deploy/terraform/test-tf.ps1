az login

az account show

$env = "local"
$appName = "iac-tf-azcli"
$params = ".\params.$env.json"

del .\.terraform*
terraform init -backend-config="$env.backend.tfvars"

terraform plan -var-file params.$env.tfvars

terraform apply -var-file params.$env.tfvars

terraform destroy -var-file params.$env.tfvars