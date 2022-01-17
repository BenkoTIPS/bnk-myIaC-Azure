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

resource "azurerm_resource_group" "rg" {
  name = "${var.env_name}-${var.app_name}-${var.tool}"
  location = "centralus"
}

resource "azurerm_app_service_plan" "plan" {
  name                = "${var.app_name}-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "linux"
  reserved = true
  sku {
    tier = "standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "site" {
  name                = "${var.env_name}-${var.app_name}-site"
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
    app_command_line = "dotnet myapp.dll"
  }
}

resource "azurerm_application_insights" "ai" {
  name = "${var.env_name}-${var.app_name}-ai"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type = "web"  
}
