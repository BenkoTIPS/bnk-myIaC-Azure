######################################################################
##  GLOBALS
######################################################################
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.0"
    }
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

data "azurerm_client_config" "current" {}

######################################################################
##  LOCALS (NAMES)
######################################################################
locals {
  rg_name           = "${var.env}-${var.app_name}-rg-${var.index}"

  app_plan_name     = "${var.env}-${var.loc}-${var.app_name}-plan-${var.index}"
  app_name          = "${var.env}-${var.loc}-${var.app_name}-web-${var.index}"
  app_insights_name = "${var.env}-${var.loc}-${var.app_name}-ai-${var.index}"
  app_config_name   = "${var.env}-${var.loc}-${var.app_name}-appcfg-${var.index}"
  keyvault_name     = "${var.env}-${var.loc}-${var.app_name}-kv-${var.index}"
  
  common_tags = {
    "CreatorId" = data.azurerm_client_config.current.object_id,
    "Environment" = "POC",
    "CreatedBy" = "Terraform CLI",
    "UpdateDt" = "${timestamp()}",
    "CostCenter" = "LTF-Platforms"
  }
}

######################################################################
##  RESOURCES
######################################################################
resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.region
  tags = local.common_tags
  lifecycle {
    ignore_changes = [name, tags]
  }
}


