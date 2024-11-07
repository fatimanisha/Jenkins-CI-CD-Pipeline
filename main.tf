# Define custom Azure RBAC roles if needed
resource "azurerm_role_definition" "custom_role" {
  name        = "CustomRoleName"
  scope       = "/subscriptions/b330d894-4acd-4a5f-8b65-fc039e25fb53"
  description = "Custom role with specific permissions"
  permissions {
    actions     = ["Microsoft.Compute/*/read", "Microsoft.Network/*/read"]
    not_actions = []
  }
  assignable_scopes = ["/subscriptions/b330d894-4acd-4a5f-8b65-fc039e25fb53"]
}

# Define role assignments for existing or custom roles
resource "azurerm_role_assignment" "role_assignment" {
  principal_id   = "<principal-id>"   # User, group, or managed identity ID
  role_definition_name = "CustomRoleName"  # Use built-in role names or custom role names
  scope          = "/subscriptions/b330d894-4acd-4a5f-8b65-fc039e25fb53/resourceGroups/demo-group"
}

# Define Azure Policy
resource "azurerm_policy_definition" "tag_policy" {
  name         = "require-tags-policy"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Require Tags on Resources"
  policy_rule  = <<POLICY
    {
      "if": {
        "field": "tags",
        "exists": "false"
      },
      "then": {
        "effect": "deny"
      }
    }
  POLICY
}

# Assign the policy to a specific scope
resource "azurerm_policy_assignment" "policy_assignment" {
  name                 = "require-tags-assignment"
  policy_definition_id = azurerm_policy_definition.tag_policy.id
  scope                = "/subscriptions/b330d894-4acd-4a5f-8b65-fc039e25fb53/resourceGroups/demo-group"
  display_name         = "Require Tags Assignment"
}
