terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=4.35.0"
    }
  }
  backend "azurerm" {
    resource_group_name = "dev0ps-practise"
    storage_account_name = "seshasac01"
    container_name = "terraform"
    key = "DEV/dev.terraform.tfstate"
    subscription_id = "62734f71-99dc-45a0-aaeb-dcd7d04d41b7"   
 
  }
}
provider "azurerm" {
    features {}
    subscription_id = "62734f71-99dc-45a0-aaeb-dcd7d04d41b7"  
}
module "dev" {
    source = "../../module"
    rg_name = "DEVRG12"
    rg_location = "UK West"
    vn_name = "DEVVN01"
    sn_name = "DEVSN01"
    AKSName = "DEVAKS01"
    acr    = "DEVACR01"
    address_space = [ "10.0.0.0/16" ]
    address_prefixes = [ "10.0.1.0/24" ]
}