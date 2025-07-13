terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "=4.35.0"
    }
  }
}
provider "azurerm" {
    features {
      
    }
    subscription_id = "62734f71-99dc-45a0-aaeb-dcd7d04d41b7"
}
resource "azurerm_resource_group" "rg_name" {
    for_each = var.resourcedetails

    name = each.value.rg_name
    location = each.value.location  
}
resource "azurerm_virtual_network" "vnet_name" {
    for_each = var.resourcedetails

    name = each.value.vnet_name
    address_space = each.value.address_space
    resource_group_name = azurerm_resource_group.rg_name[each.key].name
    location = azurerm_resource_group.rg_name[each.key].location  
}
resource "azurerm_subnet" "subnet_name" {
    for_each = var.resourcedetails
    name = each.value.subnet_name
    address_prefixes = each.value.address_prefixes
    resource_group_name = azurerm_resource_group.rg_name[each.key].name
    virtual_network_name = azurerm_virtual_network.vnet_name[each.key].name
  
}