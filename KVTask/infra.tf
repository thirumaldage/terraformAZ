
resource "azurerm_resource_group" "kv-rg" {
  name     = var.kv-rg-name
  location = var.location-name
}
resource "azurerm_virtual_network" "kv-rg" {
  name                = var.kv-vnet-name
  address_space       = ["10.0.0.0/23"]
  location            = azurerm_resource_group.kv-rg.location
  resource_group_name = azurerm_resource_group.kv-rg.name
}

resource "azurerm_subnet" "kv-rg" {
  name                 = var.kv-sub-name
  resource_group_name  = azurerm_resource_group.kv-rg.name
  virtual_network_name = azurerm_virtual_network.kv-rg.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_network_interface" "kv-rg" {
  name                = "${var.kv-vm-name}-nic"
  location            = azurerm_resource_group.kv-rg.location
  resource_group_name = azurerm_resource_group.kv-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.kv-rg.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_security_group" "kv-rg" {
  name                = "${var.kv-vm-name}-nsg"
  location            = azurerm_resource_group.kv-rg.location
  resource_group_name = azurerm_resource_group.kv-rg.name
}

resource "azurerm_network_security_rule" "kv-rg" {
  name                        = "web"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "${azurerm_network_interface.kv-rg.private_ip_address}/32"
  resource_group_name         = azurerm_resource_group.kv-rg.name
  network_security_group_name = azurerm_network_security_group.kv-rg.name
}

resource "azurerm_network_interface_security_group_association" "kv-rg" {
  network_interface_id      = azurerm_network_interface.kv-rg.id
  network_security_group_id = azurerm_network_security_group.kv-rg.id
}

resource "azurerm_virtual_machine" "kv-rg" {
  name                  = "${var.kv-vm-name}-vm01"
  location              = azurerm_resource_group.kv-rg.location
  resource_group_name   = azurerm_resource_group.kv-rg.name
  network_interface_ids = [azurerm_network_interface.kv-rg.id]
  vm_size               = "Standard_B2s"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.kv-vm-name}-osdisk"
    managed_disk_type = "StandardSSD_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  os_profile {
    computer_name  = "${var.kv-vm-name}-vm01"
    admin_username = var.admin_username
    admin_password = data.azurerm_key_vault_secret.kv01.value
  }
  os_profile_windows_config {
    enable_automatic_upgrades = true
    provision_vm_agent        = true
  }
}

resource "azurerm_virtual_machine_extension" "kv-rg" {
  name                 = "iis-extension"
  virtual_machine_id   = azurerm_virtual_machine.kv-rg.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  settings             = <<SETTINGS
    {
        "commandToExecute": "powershell Install-WindowsFeature -name Web-Server -IncludeManagementTools;"
    }
SETTINGS
}