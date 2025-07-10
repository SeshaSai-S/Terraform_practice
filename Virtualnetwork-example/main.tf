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
resource "azurerm_resource_group" "rgname" {
  name = "sohini-rg"
  location = "UK West"  
}
resource "azurerm_virtual_network" "vnname" {
  name = "sohini-vn"
  resource_group_name = azurerm_resource_group.rgname.name
  location = azurerm_resource_group.rgname.location
  address_space = ["10.0.0.0/16"]
}
resource "azurerm_subnet" "snname" {
  name = "sohini02sn"
  resource_group_name = azurerm_resource_group.rgname.name
  virtual_network_name = azurerm_virtual_network.vnname.name
  address_prefixes = ["10.0.1.0/24"]
}