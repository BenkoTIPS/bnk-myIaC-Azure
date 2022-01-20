    resource_group_name  = "#{TF_STORAGE_RG}#"
    storage_account_name = "#{TF_STORAGE_ACCT}#"
    container_name       = "tfstatedevops"
    key = "tf-deploy-#{APP_NAME}#-#{ENV_NAME}#.tfstate"