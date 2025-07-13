terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "=4.35.0"
    }
  }
}
provider "azurerm" {
    features {
      
    }
    subscription_id = "62734f71-99dc-45a0-aaeb-dcd7d04d41b7"
}
resource "azurerm_resource_group" "rg_name" {
    for_each = var.resourcedetails

    name = each.value.rg_name
    location = each.value.location  
}
resource "azurerm_virtual_network" "vnet_name" {
    for_each = var.resourcedetails

    name = each.value.vnet_name
    address_space = each.value.address_space
   location = each.value.location
    resource_group_name = each.value.rg_name 
}
resource "azurerm_subnet" "subnet_name" {
    for_each = var.resourcedetails
    name = each.value.subnet_name
    address_prefixes = each.value.address_prefixes
    resource_group_name = each.value.rg_name
    virtual_network_name = each.value.vnet_name
  
}
resource "azurerm_network_interface" "nic" {
    for_each = var.resourcedetails
    name = "my-nic"
    location = each.value.location
    resource_group_name = each.value.rg_name
    ip_configuration {
      name = "my-ip-config"
      subnet_id = azurerm_subnet.subnet_name[each.key].id
      private_ip_address_allocation = "Dynamic"
    }
}
resource "azurerm_virtual_machine" "vm" {
    for_each = var.resourcedetails

    name = each.value.vm_name
    location = each.value.location
    resource_group_name = each.value.rg_name
    network_interface_ids = [azurerm_network_interface.nic[each.key].id]
    vm_size = each.value.size  

    storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${each.value.vm_name}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = each.value.vm_name
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
 }
}