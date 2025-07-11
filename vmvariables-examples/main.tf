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
resource "azurerm_network_interface" "nic_name" {
    name = var.nic_name
    location = var.rg_location
    resource_group_name = var.rg_name
    ip_configuration {
      name = "internal"
      subnet_id = azurerm_subnet.sn_name.id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.pip_name.id
    }  
    depends_on = [ azurerm_resource_group.rg_name,azurerm_subnet.sn_name ]
}
resource "azurerm_public_ip" "pip_name" {
   name = var.pip_name
   resource_group_name = var.rg_name
   location = var.rg_location
   allocation_method = "Static"  
}
resource "azurerm_network_security_group" "nsg_name" {
  name                = var.nsg_name
  location            = var.rg_location
  resource_group_name = var.rg_name
}
resource "azurerm_network_security_rule" "nsr_name" {
  name                        = var.nsr_name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = var.nsg_name
}
resource "azurerm_subnet_network_security_group_association" "snsga01" {
  subnet_id                 = azurerm_subnet.sn_name.id
  network_security_group_id = azurerm_network_security_group.nsg_name.id
}
resource "azurerm_windows_virtual_machine" "vm_name" {
  name                = var.vm_name
  resource_group_name = var.rg_name
  location            = var.rg_location
  size                = "Standard_F2"
  admin_username      = "sesha"
  admin_password      = "sesha@123456"
  network_interface_ids = [
    azurerm_network_interface.nic_name.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  depends_on = [ azurerm_resource_group.rg_name ]
}
