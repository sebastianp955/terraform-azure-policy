terraform {
  required_providers {
    azurerm = {
      source  = "Hashicorp/azurerm"
      version = "4.49.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
}

locals {
  subscription_resource_id = "/subscriptions/${var.azure_subscription_id}"
}

data "azurerm_policy_definition" "allowed_locations_definition" {
  name = "e56962a6-4747-49cd-b67b-bf8b01975c4c"
}

resource "azurerm_subscription_policy_assignment" "allowed_locations_scope" {
  name                 = data.azurerm_policy_definition.allowed_locations_definition.name
  display_name = data.azurerm_policy_definition.allowed_locations_definition.display_name
  description = data.azurerm_policy_definition.allowed_locations_definition.description
  policy_definition_id = data.azurerm_policy_definition.allowed_locations_definition.id
  subscription_id      = local.subscription_resource_id
  parameters = jsonencode({
    "listOfAllowedLocations" : {
      "value" = ["northcentralus", "westus3", "southcentralus", "centralus", "westus"]
      }
    })
}