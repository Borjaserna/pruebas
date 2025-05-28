output "network_id" {
  description = "ID de la red virtual"
  value       = azurerm_virtual_network.vnet.id
}

output "vm_public_ip" {
  description = "Dirección IP pública de la VM"
  value       = azurerm_public_ip.vm_ip.id
}

output "log_analytics_workspace_id" {
  description = "ID del Workspace de Log Analytics"
  value       = azurerm_log_analytics_workspace.log_analytics.id
}
