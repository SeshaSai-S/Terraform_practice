terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurem"
        version = "=4.35.0"
    }      
  }
}
provider "azurem" {
    features {}
    subscription_id = "62734f71-99dc-45a0-aaeb-dcd7d04d41b7"  
}
resource "azurerm_resource_group" "az_rg12" {
    name = var.az_rg12
    location = var.rg_location  
}
resource "azurerm_virtual_network" "vn_name" {
  name                = var.vn_name
  location            = azurerm_resource_group.az_rg12.location
  resource_group_name = azurerm_resource_group.az_rg12.name
  address_space       = ["10.0.0.0/16"]
}
resource "azurerm_subnet" "Rohinisn12" {
    name = var.Rohinisn12
    virtual_network
  
}