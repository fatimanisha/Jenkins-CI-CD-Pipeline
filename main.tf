# Terraform Provider
provider "azurerm" {
  subscription_id = "b330d894-4acd-4a5f-8b65-fc039e25fb53"
  features {}
  use_msi = true
}
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "North Europe"
}

resource "azurerm_storage_account" "example" {
  name                     = "azureuser19"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
