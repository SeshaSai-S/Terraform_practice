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
resource "azurerm_resource_group" "rg_name" {
    name = var.rg_name
    location = var.rg_location  
}
resource "azurerm_virtual_network" "vn_name"{
    name = var.vn_name
    resource_group_name = var.rg_name
    location = var.rg_location
    address_space = ["10.0.0.0/16"]
    depends_on = [ azurerm_resource_group.rg_name ]
}
resource "azurerm_subnet" "sn_name" {
    name = var.sn_name
    resource_group_name = var.rg_name
    virtual_network_name = var.vn_name
    address_prefixes = ["10.0.1.0/24"] 
    depends_on = [ azurerm_virtual_network.vn_name ]
}