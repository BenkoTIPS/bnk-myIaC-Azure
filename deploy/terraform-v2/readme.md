# TF with Keyvault and App Service - Proof of Concept

The purpose of this section is to test the naming, deployment and use of keyvaults with an application service. To deploy ensure that you have Terraform installed (or in a local path) and then run the commands:


```
PS C:\work>  terraform init
PS C:\work>  terraform plan
PS C:\work>  terraform apply
```

The resulting infrastructure created includes 3 resources:

- An AppSvc hosting plan
- A Web App in the Hosting plan
- A Keyvault containing a secret and policies for the creator (to set the value) and the web AppSvc that can read the value

The configuration uses managed identity of the Web AppSvc to authenticate against the policy of the Key Vault.