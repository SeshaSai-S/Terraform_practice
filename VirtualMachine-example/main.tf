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
resource "azurerm_resource_group" "az-rg01" {
  name = "Hishalrg01"
  location =  "UK West"  
}
resource "azurerm_virtual_network" "az-vm01"{
  name = "hishalvm01"
  resource_group_name = azurerm_resource_group.az-rg01.name
  location = azurerm_resource_group.az-rg01.location
  address_space = ["10.0.0.0/16"]
}
resource "azurerm_subnet" "az-sn01" {
  name = "Hishalsn01"
  virtual_network_name = azurerm_virtual_network.az-vm01.name
  resource_group_name = azurerm_resource_group.az-rg01.name
  address_prefixes = ["10.0.1.0/24"]  
}
resource "azurerm_network_security_group" "nsg01" {
  name = "hishalnsg01"
  resource_group_name = azurerm_resource_group.az-rg01.name
  location = azurerm_resource_group.az-rg01.location
}
resource "azurerm_network_security_rule" "nsr01" {
  name                        = "hishalnsr01"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.az-rg01.name
  network_security_group_name = azurerm_network_security_group.nsg01.name
}
resource "azurerm_subnet_network_security_group_association" "snsga01" {
  subnet_id = azurerm_subnet.az-sn01.id
  network_security_group_id = azurerm_network_security_group.nsg01.id
}
resource "azurerm_public_ip" "pip01" {
  name = "hishalpip01"
  resource_group_name = azurerm_resource_group.az-rg01.name
  location = azurerm_resource_group.az-rg01.location
  allocation_method = "Static"  
}
resource "azurerm_network_interface" "nic01" {
  name= "hishalnic01"
  resource_group_name = azurerm_resource_group.az-rg01.name
  location = azurerm_resource_group.az-rg01.location  
  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.az-sn01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip01.id
  }
}
resource "azurerm_linux_virtual_machine" "azvm01" {
  name     = "hishalvm01"
  resource_group_name = azurerm_resource_group.az-rg01.name
  location  = azurerm_resource_group.az-rg01.location
  network_interface_ids = [ azurerm_network_interface.nic01.id, 
  ]
  size = "Standard_F2"
  admin_username = "sesha"
  disable_password_authentication = true
  admin_ssh_key {
    username   = "sesha"
    public_key = file("~/.ssh/id_rsa.pub")  # Make sure this file exists
  }
   os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
