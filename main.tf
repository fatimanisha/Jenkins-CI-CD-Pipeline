provider "azurerm" {
  features {}
  use_msi = true  
  subscription_id = "b330d894-4acd-4a5f-8b65-fc039e25fb53"
}

# Subscription Data
data "azurerm_subscription" "current" {}

# Resource Group
resource "azurerm_resource_group" "vm_sku_policy" {
  name     = "test-resources"
  location = "West Europe"
}

# Policy Definition
resource "azurerm_policy_definition" "vm_sku_policy" {
  name         = "OnlyAllowHostingCROSImages"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Limit allowed VM SKUs"
  description  = "This policy restricts the VM SKUs that can be deployed in the subscription."

  policy_rule = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "in": [
            "Microsoft.Compute/virtualMachines",
            "Microsoft.Compute/virtualMachineScaleSets"
          ]
        },
        {
          "not": {
            "anyOf": [
              {
                "field": "Microsoft.Compute/imageSku",
                "like": "*-Datacenter-gs"
              },
              {
                "field": "Microsoft.Compute/imageSku",
                "like": "2022-Datacenter*"
              },
              {
                "allOf": [
                  {
                    "field": "Microsoft.Compute/imagePublisher",
                    "equals": "Canonical"
                  },
                  {
                    "field": "Microsoft.Compute/imageOffer",
                    "in": [
                      "0001-com-ubuntu-server-focal",
                      "0001-com-ubuntu-server-jammy",
                      "UbuntuServer"
                    ]
                  },
                  {
                    "field": "Microsoft.Compute/imageSku",
                    "in": [
                      "20_04-lts-gen2",
                      "20_04-lts-cvm",
                      "22_04-lts-cvm",
                      "20_04-lts",
                      "22_04-lts"
                    ]
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "then": {
      "effect": "deny"
    }
  }
POLICY_RULE
}

# User-Assigned Managed Identity
resource "azurerm_user_assigned_identity" "policy_assignment_identity" {
  resource_group_name = azurerm_resource_group.vm_sku_policy.name
  location            = azurerm_resource_group.vm_sku_policy.location
  name                = "policyAssignmentIdentity"
}

# Policy Assignment with Identity
resource "azurerm_subscription_policy_assignment" "example" {
  name                 = "limit-vm-sku-assignment"
  policy_definition_id = azurerm_policy_definition.vm_sku_policy.id
  subscription_id      = data.azurerm_subscription.current.id
  location             = "West Europe"  

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.policy_assignment_identity.id]
  }
}

# Role Assignment for Policy Contributor Role
resource "azurerm_role_assignment" "policy_contributor_assignment" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Resource Policy Contributor"
  principal_id         = azurerm_user_assigned_identity.policy_assignment_identity.principal_id
}
