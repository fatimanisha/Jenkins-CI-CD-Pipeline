terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0"
    }
  }
}

provider "azurerm" {
  features {}
  use_msi = true  # Assuming you are using Managed Identity
  subscription_id = "<your-subscription-id>"
}
