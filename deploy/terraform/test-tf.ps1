az login

az account show

$env = "local"
$appName = "iac-tf-azcli"
$params = ".\params.$env.tfvars"

del .\.terraform*
terraform init -backend-config="backend.$env.tfvars"

terraform plan -var-file params.$env.tfvars

terraform apply -var-file params.$env.tfvars

terraform destroy -var-file params.$env.tfvars