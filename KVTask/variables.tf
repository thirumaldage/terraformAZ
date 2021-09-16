
/*rg be-rg
vnet web-vnet
subnet web-subnet
nsg web-nsg
nic web-nic
vm web-vm01
rg fe-rg
pip pub-ip01
fw  fw-01
vnet fe-vnet
rg jbox-rg
vm jbox-vm01
nic jbox-nic
nsg jbox-nsg*/
# Please use terraform v12.29 to start with for all labs, I will use terraform v13 and v14 from lab 7.5 onwards


variable "kv-rg-name" {
  type    = string
  default = "Kv-rg"
}
variable "location-name" {
  type    = string
  default = "westeurope"
}
variable "kv-vnet-name" {
  type    = string
  default = "Kv-vnet"
}
variable "kv-sub-name" {
  type    = string
  default = "Kv-subnet"
}
variable "kv-vm-name" {
  type    = string
  default = "Web"
}
variable "admin_username" {
  type    = string
  default = "testadmin"
}
