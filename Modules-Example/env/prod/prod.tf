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
module "dev" {
    source = "../../module"
    rg_name = "PRODRG12"
    rg_location = "UK West"
    vn_name = "PRODVN01"
    sn_name = "PRODSN01"
    AKSName = "PRODAKS01"
    acr    = "PRODACR01"
    address_space = [ "10.0.0.0/16" ]
    address_prefixes = [ "10.0.1.0/24" ]
}