terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=4.35.0"
    }
  }
  backend "azurerm" {
    resource_group_name = "devops-practise"
    storage_account_name = "seshasac15"
    container_name = "terraform"
    key = "PROD/prod.terraform.tfstate"
    subscription_id = "62734f71-99dc-45a0-aaeb-dcd7d04d41b7"    
  }
}
provider "azurerm" {
    features {}
    subscription_id = "62734f71-99dc-45a0-aaeb-dcd7d04d41b7"  
}
module "dev" {
    source = "../../module"
    rg_name = "PRODRG123"
    rg_location = "UK West"
    vn_name = "PRODVN013"
    sn_name = "PRODSN013"
    AKSName = "PRODAKS013"
    acr    = "PRODACR013"
    address_space = [ "10.0.0.0/16" ]
    address_prefixes = [ "10.0.1.0/24" ]
}