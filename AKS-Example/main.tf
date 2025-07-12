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
resource "azurerm_container_registry" "acr" {
  name                = var.acr
  resource_group_name = azurerm_resource_group.rg_name.name
  location            = azurerm_resource_group.rg_name.location
  sku                 = "Premium"
  admin_enabled = true
}
resource "azurerm_kubernetes_cluster" "AKSName" {
  name                = var.AKSName
  location            = azurerm_resource_group.rg_name.location
  resource_group_name = azurerm_resource_group.rg_name.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
    vnet_subnet_id = azurerm_subnet.sn_name.id
    type = "VirtualMachineScaleSets"
  }
  network_profile {
    network_plugin = "azure"
    network_policy = "calico"
    service_cidr       = "10.2.0.0/16"
    dns_service_ip     = "10.2.0.10"
    load_balancer_sku = "standard"
  }

  identity {
    type = "SystemAssigned"
  }
  depends_on = [ azurerm_virtual_network.vn_name, azurerm_subnet.sn_name,azurerm_container_registry.acr ]
 }
  resource "azurerm_role_assignment" "aks2acr" {
  principal_id                     = azurerm_kubernetes_cluster.AKSName.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}


