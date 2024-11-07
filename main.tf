provider "azurerm" {
  features {}
  use_msi = true  
  subscription_id = "b330d894-4acd-4a5f-8b65-fc039e25fb53"
}
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

data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "vm_sku_policy" {
  name     = "test-resources"
  location = "West Europe"
}

resource "azurerm_subscription_policy_assignment" "example" {
  name                 = "exlimit-vm-sku-assignmentample"
  policy_definition_id = azurerm_policy_definition.vm_sku_policy.id
  subscription_id      = data.azurerm_subscription.current.id
}

# Role assignment to allow the policy assignment to function correctly
resource "azurerm_role_assignment" "policy_contributor_assignment" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Policy Contributor"
  principal_id         = azurerm_subscription_policy_assignment.example.identity[0].principal_id
}