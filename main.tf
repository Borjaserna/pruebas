resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-security"
  location            = var.location
  resource_group_name = "rg-security-monitoring"
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "private_subnet" {
  name                 = "private-subnet"
  resource_group_name  = "rg-security-monitoring"
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "vm_ip" {
  name                = "vm-public-ip"
  location            = var.location
  resource_group_name = "rg-security-monitoring"
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "vm_nic" {
  name                = "vm-nic"
  location            = var.location
  resource_group_name = "rg-security-monitoring"

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
  resource_group_name   = "rg-security-monitoring"
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
  resource_group_name = "rg-security-monitoring"
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_policy_definition" "vm_restriction" {
  name         = "restrict-vm-sizes"
  display_name = "Restricción de Tamaños de VM"  
  policy_type  = "Custom"
  mode         = "All"

  policy_rule = <<RULE
    {
      "if": {
        "field": "Microsoft.Compute/virtualMachines/sku.name",
        "notIn": ["Standard_DS1_v2", "Standard_DS2_v2"]
      },
      "then": {
        "effect": "deny"
      }
    }
  RULE
}

resource "azurerm_subscription_policy_assignment" "vm_restriction_assignment" {
  name                 = "vm-restriction-assignment"
  subscription_id      = "/subscriptions/202bcb41-aac1-46a6-9301-fa2a1c4f9aee"
  policy_definition_id = azurerm_policy_definition.vm_restriction.id
}
