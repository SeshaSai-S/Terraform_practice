variable "resourcedetails" {
    type = map(object({
      vm_name = string
      location = string
      size = string
      rg_name = string
      vnet_name = string
      subnet_name = string
      address_space = list(string)
      address_prefixes = list(string)
    }))
}