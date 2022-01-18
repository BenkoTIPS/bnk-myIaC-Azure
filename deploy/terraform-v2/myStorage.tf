resource "azurerm_storage_account" "my_storage" {
  name                     = "${lower(var.app_name)}${lower(var.loc)}${lower(var.index)}lrs"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  account_tier = "Standard"
  account_replication_type = "LRS"
  tags = local.common_tags
}

# Add my-storage
resource "azurerm_key_vault_secret" "my_storage_secret" {
  name         = "my-storage"
  value        = azurerm_storage_account.my_storage.primary_connection_string
  key_vault_id = azurerm_key_vault.my_keyvault.id
  depends_on = [
    azurerm_key_vault_access_policy.keyvault_policy_owner,
    azurerm_storage_account.my_storage
  ]
  # UNCOMMENT lifecyle SECTION BELOW IF UPDATING SECRETS OUTSIDE OF TF
  # lifecycle {
  #   ignore_changes = [value, version]
  # }
}