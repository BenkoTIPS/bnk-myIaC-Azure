######################################################################
##  GLOBALS
######################################################################
resource "azurerm_app_service_plan" "plan" {
  name                = local.app_plan_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind ="Linux"
  reserved = true
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "my_app" {
  name                = local.app_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.plan.id

  site_config {
    linux_fx_version = "DONETCORE|6.0"
  }

  depends_on = [
    azurerm_app_service_plan.plan
  ]
  
  app_settings = {
    "EnvName"         = "Terraform and Key Vault"
    "FavoriteColor"   = "PaleTurquoise"
    "MySecret"        = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.my_secret.versionless_id})"
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.appinsights.instrumentation_key
  }
  
  identity {
    type = "SystemAssigned"
  }
  
  connection_string {
    name      = "MyStorage"
    type      = "Custom"
    value     = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.my_storage_secret.versionless_id})"
  }
}

# Create application insights
resource "azurerm_application_insights" "appinsights" {
  name                = local.app_insights_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
  tags = local.common_tags
}

resource "azurerm_key_vault_access_policy" "keyvault_policy_myApp" {
  key_vault_id = azurerm_key_vault.my_keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_app_service.my_app.identity[0].principal_id
  secret_permissions = [
    "Get"
  ]
  depends_on = [
    azurerm_key_vault.my_keyvault
  ]
}