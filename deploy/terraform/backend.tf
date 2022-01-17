terraform {
  backend "azurerm" {
    resource_group_name  = "poc-shared-tfstate"
    storage_account_name = "poceusastfstate"
    container_name       = "tfstatedevops"
    key                  = "bnk-myiac-tf-azcli.tfstate"
  }
}