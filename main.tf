# Terraform Provider
provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
  use_msi = true
  subscription_id = "b330d894-4acd-4a5f-8b65-fc039e25fb53"
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "Canada Central"
}

resource "azurerm_storage_account" "example" {
  name                     = "examplestoracc"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
