# Terraform Provider
provider "azurerm" {
  features {}
  use_msi = true
  subscription_id = "aff84979-cede-467f-9d23-1088fcd2df1f"
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East US"
}

resource "azurerm_storage_account" "example" {
  name                     = "examplestoracc"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
