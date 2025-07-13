terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=4.35.0"
    }
  }
}
provider "azurerm" {
    features {}
    subscription_id = "62734f71-99dc-45a0-aaeb-dcd7d04d41b7"  
}
resource "azurerm_resource_group" "myrg" {
   name = var.rgname
   location = var.rglocation  
}
resource "azurerm_virtual_network" "myvnet" {
    name = var.myvnet
    resource_group_name = var.rgname
   location = var.rglocation
   address_space = var.address_space  
}
resource "azurerm_subnet" "mysubnet" {
    count = length(var.mysubnet)
    name = var.mysubnet[count.index]
    virtual_network_name = var.myvnet
    resource_group_name = var.rgname
    address_prefixes = [var.address_prefixes[count.index]]  
}