variable "rgname" {
    type = string  
}
variable "rglocation" {
    type = string
}
variable "myvnet" {
    type = string
}
variable "address_space" {
    type = list(string)
}
variable "mysubnet" {
    type = list(string)
}
variable "address_prefixes" {
    type = list(string)
  
}