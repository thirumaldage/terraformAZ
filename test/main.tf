
 #Please use terraform v12.29
 
 provider "azurerm" {
  version = "= 2.18"
  features {}
}
resource "azurerm_resource_group" "myRG" {
	name = "testRG"
	location = "westeurope"
}