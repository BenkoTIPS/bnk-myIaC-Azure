terraform {
  required_providers { 
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 2.92.0"
    }
  }
  
  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

variable "app_name" { 
    type = string
    default="IaC-TF" 
}
variable "env_name" { 
    type=string
    default="bnk"
}
variable "tool" {
    type=string
    default="azcli"
}

locals {
  rg_name   = "${var.tool}-${var.env_name}-${var.app_name}"
  host_name = "${var.tool}-${var.env_name}-${var.app_name}-plan"
  site_name = "${var.tool}-${var.env_name}-${var.app_name}-site"
  ai_name   = "${var.tool}-${var.env_name}-${var.app_name}-ai"

  common_tags = {
    "CreatorId"   = data.azurerm_client_config.current.object_id,
    "Environment" = "#{ENV_NAME}#",
    "CreatedBy"   = "#{GITHUB_ACTOR}#",
    "Repo"        = "#{GITHUB_REPOSITORY}#"
    "CreateDt"    = "${formatdate("YY-MM-DD hh:mm",timestamp())}",
    "CostCenter"  = "BenkoTips-DEMOS"
    "Commit"      = "#{SHORT_SHA}#"
    "TF-State-Key" = "tf-deploy-#{APP_NAME}#-#{ENV_NAME}#.tfstate"
  }  
}

resource "azurerm_resource_group" "rg" {
  name = local.rg_name
  location = "centralus"
  tags = local.common_tags
  lifecycle {
    ignore_changes = [tags]
  }
}


resource "azurerm_app_service_plan" "plan" {
  name                = local.host_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "linux"
  reserved = true
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "site" {
  name                = local.site_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.plan.id
  app_settings = {
    EnvName = var.app_name
    FavoriteColor = "lightpink"
    APPLICATION_INSIGHTSKEY = azurerm_application_insights.ai.instrumentation_key
  }
  site_config  {
    dotnet_framework_version = "v6.0"
    linux_fx_version = "DOTNETCORE|6.0"
    app_command_line = "dotnet myapp.dll"
  }
}

resource "azurerm_application_insights" "ai" {
  name                = local.ai_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type = "web"  
}
