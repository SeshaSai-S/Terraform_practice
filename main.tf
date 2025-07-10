terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=4.35.0"
    }
  }
}
provider "azurerm" {
  features{}
  subscription_id = "62734f71-99dc-45a0-aaeb-dcd7d04d41b7"
}
resource "azurerm_resource_group" "rg-name" {
  name = "devops-practise-rg"
  location = "UK West"  
}
resource "azurerm_virtual_network" "vn-name" {
  name = "seshavn01"
  resource_group_name = azurerm_resource_group.rg-name.name
  location = azurerm_resource_group.rg-name.location
  address_space = ["10.0.0.0/16"]  
}
resource "azurerm_subnet" "namesn01" {
  name = "seshasn01"
  resource_group_name = azurerm_resource_group.rg-name.name
  virtual_network_name = azurerm_virtual_network.vn-name.name
  address_prefixes = ["10.0.1.0/24"]  
}
resource "azurerm_subnet" "namesn02" {
  name = "seshasn02"
  resource_group_name = azurerm_resource_group.rg-name.name
  virtual_network_name = azurerm_virtual_network.vn-name.name
  address_prefixes = ["10.0.0.0/24"]
}