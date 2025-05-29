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

# Workspace de Log Analytics para recopilar métricas y logs
resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "log-analytics-workspace"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Capturar Logs de actividad en Azure Monitor
resource "azurerm_monitor_activity_log_alert" "vm_activity_logs" {
  name                = "vm-activity-alert"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "global"
  scopes              = [azurerm_virtual_machine.vm.id]

  criteria {
    category = "Administrative"
    operation_name = "Microsoft.Compute/virtualMachines/write"
  }

  action {
    action_group_id = azurerm_monitor_action_group.alert_action_group.id
  }
}

# 📌 Grupo de acción para alertas en Azure Monitor
resource "azurerm_monitor_action_group" "alert_action_group" {
  name                = "vm-alerts-action-group"
  resource_group_name = azurerm_resource_group.rg.name
  short_name          = "VMAlerts"

  email_receiver {
    name          = "AdminEmail"
    email_address = "admin@example.com"
  }
}

# 📌 Dashboard en Azure Monitor usando azurerm_dashboard
resource "azurerm_dashboard" "vm_dashboard" {
  name                = "vm-performance-dashboard"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  tags                = {}

  dashboard_properties = <<PROPS
{
  "lenses": {
    "0": {
      "order": 0,
      "parts": {
        "0": {
          "position": { "x": 0, "y": 0, "rowSpan": 2, "colSpan": 3 },
          "metadata": {
            "inputs": [
              { "name": "resourceType", "value": "Microsoft.Compute/virtualMachines" },
              { "name": "resourceId", "value": "${azurerm_virtual_machine.vm.id}" }
            ],
            "type": "Extension/HubsExtension/PartType/ResourceGraph" 
          }
        }
      }
    }
  },
  "metadata": {
    "model": {
      "timeRange": {
        "value": {
          "relative": "24h"
        },
        "type": "MsPortalFx.Composition.Configuration.ValueTypes.TimeRange" 
      }
    }
  }
}
PROPS
}
