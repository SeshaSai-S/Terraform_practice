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
  name = " sesha-vn"
  resource_group_name = azurerm_resource_group.rg-name.name
  location = azurerm_resource_group.rg-name.location
  address_space = ["10.0.0.2/16"]  
}
  