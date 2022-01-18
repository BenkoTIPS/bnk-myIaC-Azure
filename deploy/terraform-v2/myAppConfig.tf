######################################################################
##  Azure App Configuration
######################################################################
resource "azurerm_app_configuration" "appconf" {
  name                = local.app_config_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  identity {
    type = "SystemAssigned"
  }
}

#data "azurerm_client_config" "current" {}

## SET ROLE OWNER
resource "azurerm_role_assignment" "appconf_dataowner" {
  scope                = azurerm_app_configuration.appconf.id
  role_definition_name = "App Configuration Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}

## ADD test KEY and LABEL
resource "azurerm_app_configuration_key" "test" {
  configuration_store_id = azurerm_app_configuration.appconf.id
  key                    = "appConfKey1"
  label                  = "somelabel"
  value                  = "a test"

  depends_on = [
    azurerm_role_assignment.appconf_dataowner
  ]
}
