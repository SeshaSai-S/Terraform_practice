resourcedetails = {
  "WestUS" = {
    vm_name = "West_vm"
    location = "West US"
    size = "Standard-B1s"
    rg_name = "west-rg"
    vnet_name = "westvnet"
    subnet_name = "subnet01"
    address_space = ["10.10.0.0/16"]
    address_prefixes = ["10.10.0.0/16"]    
  }
    "EastUS" = {
    vm_name = "East_vm"
    location = "East US"
    size = "Standard-B1s"
    rg_name = "east-rg"
    vnet_name = "eastvnet"
    subnet_name = "subnet02"
    address_space = ["10.20.0.0/16"]
    address_prefixes = ["10.20.0.0/16"]    
  }
}