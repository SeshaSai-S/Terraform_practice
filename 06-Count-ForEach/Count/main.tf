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
resource "azurerm_resource_group" "myrg" {
   name = var.myrg
   location = var.rglocation  
}
resource "azurerm_virtual_network" "myvnet" {
    name = var.myvnet
    resource_group_name = var.myrg
   location = var.rglocation
   address_space = var.address_space  
}
resource "azurerm_subnet" "mysubnet" {
    count = length(var.mysubnet)
    name = var.mysubnet[count.index]
    virtual_network_name = var.myvnet
    resource_group_name = var.myrg
    address_prefixes = [var.address_prefixes[count.index]]  
}
resource "azurerm_network_security_group" "nsg01" {
  name = "hishalnsg01"
  resource_group_name = azurerm_resource_group.myrg.name
  location = azurerm_resource_group.myrg.location
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
  resource_group_name         = azurerm_resource_group.myrg.name
  network_security_group_name = azurerm_network_security_group.nsg01.name
}
resource "azurerm_subnet_network_security_group_association" "snsga01" {
  subnet_id = azurerm_subnet.mysubnet.id
  network_security_group_id = azurerm_network_security_group.nsg01.id
}
resource "azurerm_public_ip" "pip123" {
  count = length(var.pip123)   
  name = var.pip123[count.index]
  resource_group_name = azurerm_resource_group.myrg.name
  location = azurerm_resource_group.myrg.location
  allocation_method = "Static"  
}
resource "azurerm_network_interface" "nic_name" {
  count = 3
  name = "nic_name-${count.index}"
  resource_group_name = azurerm_resource_group.myrg.name
  location = azurerm_resource_group.myrg.location  
  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip123.id
  }
}
resource "azurerm_linux_virtual_machine" "myvm" {
  count = 3 
  name     = "vm01-${count.index}"
  resource_group_name = azurerm_resource_group.myrg.name
  location  = azurerm_resource_group.myrg.location
  network_interface_ids = [ azurerm_network_interface.nic_name[count.index].id, 
  ]
  size = "Standard_F2"
  admin_username = "sesha1"
  disable_password_authentication = true
  admin_ssh_key {
    username   = "sesha1"
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