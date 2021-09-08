<<<<<<< HEAD
 #Please use terraform v12.29
 
 provider "azurerm" {
  version = "= 2.18"
  features {}
}
resource "azurerm_resource_group" "myRG" {
	name = "testRG"
	location = "westeurope"
=======
 #Please use terraform v12.29
 
 provider "azurerm" {
  version = "= 2.18"
  features {}
}
resource "azurerm_resource_group" "myRG" {
	name = "testRG"
	location = "westeurope"
>>>>>>> 1138ad00c9f136a88f788031c3aad5efe33962f4
}