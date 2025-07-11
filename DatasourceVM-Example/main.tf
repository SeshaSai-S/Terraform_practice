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
data "azurerm_resource_group" "existing-rg" {
    name = "NextOPSRGT15" 
}
output "id" {
    value = data.azurerm_resource_group.existing-rg.location
}
data "azurerm_virtual_network" "existing_vn" {
  name                = "NextOPSVN15"
  resource_group_name = data.azurerm_resource_group.existing-rg.name
}
data "azurerm_subnet" "existing-subnet01" {
  name                 = "subnet01"
  virtual_network_name = data.azurerm_virtual_network.existing_vn.name
  resource_group_name  = data.azurerm_resource_group.existing-rg.name
}
data "azurerm_subnet" "existing-subnet02" {
  name                 = "subnet02"
  virtual_network_name = data.azurerm_virtual_network.existing_vn.name
  resource_group_name  = data.azurerm_resource_group.existing-rg.name
}
data "azurerm_network_security_group" "existing_nsg" {
  name                = "NextopsNSG15"
  resource_group_name = data.azurerm_resource_group.existing-rg.name
}
resource "azurerm_network_interface" "newnic" {
  name                = "newnic"
  location            = data.azurerm_resource_group.existing-rg.location
  resource_group_name = data.azurerm_resource_group.existing-rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.existing-subnet01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip15.id
  }
}
resource "azurerm_public_ip" "pip15" {
  name                = "PublicIp1"
  location            = data.azurerm_resource_group.existing-rg.location
  resource_group_name = data.azurerm_resource_group.existing-rg.name
  allocation_method   = "Static"
  tags = {
    environment = "Production"
  }
}
resource "azurerm_linux_virtual_machine" "Rohini-sai" {
  name                = "DataVM15"
  location            = data.azurerm_resource_group.existing-rg.location
  resource_group_name = data.azurerm_resource_group.existing-rg.name
  size                = "Standard_B1s"
  admin_username      = "seshasai"
  network_interface_ids = [
    azurerm_network_interface.newnic.id,
  ]

  admin_ssh_key {
    username   = "seshasai"
    public_key = file("~/.ssh/id_rsa.pub")
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

