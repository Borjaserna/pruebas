resource "azurerm_resource_group" "rg" {
  name     = "rg-security-monitoring"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-security"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "private_subnet" {
  name                 = "private-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "vm_ip" {
  name                = "vm-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "vm_nic" {
  name                = "vm-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.private_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_ip.id
  }
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "vm-security"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.vm_nic.id]
  vm_size               = var.vm_size

  storage_os_disk {
    name              = "vm-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "vm-security"
    admin_username = "adminuser"
    admin_password = "YourSecurePassword123!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "log-analytics-workspace"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_policy_assignment" "allowed_vm_sizes" {
  name                 = "allowed-vm-sizes"
  scope                = azurerm_resource_group.rg.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/0a914e76-4921-4c3c-8ae3-fb9b94b2b1a2" # Built-in: Allowed virtual machine SKUs
  parameters = <<PARAMS
    {
      "listOfAllowedSKUs": {
        "value": ["Standard_DS1_v2", "Standard_DS2_v2"]
      }
    }
  PARAMS
}
