data "azurerm_key_vault" "kv01" {
  name                = "Kvult-011"
  resource_group_name = "kv-rg"
}

data "azurerm_key_vault_secret" "kv01" {
  name         = "admin"
  key_vault_id = data.azurerm_key_vault.kv01.id
}