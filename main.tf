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
}
resource "azurerm_resource_group" "rg-name" {
  name = "devops-practise"
  location = "UK West"  
}
resource "azurerm_virtual_network" "vn-name" {
  name = " sesha-vn"
  resource_group_name = azurerm_resource_group.rg-name.name
  location = azurerm_resource_group.rg-name.location
  address_space = ["10.0.0.1/16"]  
}
  