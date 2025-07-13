terraform {
  required_providers {
    azurerm {
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
    count = length(var.rgname)
    name =  var.rgname[count.index]
    location = var.rglocation
  
}