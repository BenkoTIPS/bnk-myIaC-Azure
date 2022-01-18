terraform {
  backend "azurerm" {
    resource_group_name  = "poc-shared-tfstate"
    storage_account_name = "poceusastfstate"
    container_name       = "txazug22"
    #key                  = "bnk-myiac-tf-azcli.tfstate"
  }
}