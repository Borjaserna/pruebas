# Exporta el ID de la red virtual creada para su uso externo o referencia
output "network_id" {
  description = "ID de la red virtual"
  value       = azurerm_virtual_network.vnet.id
}

# Exporta la dirección IP pública asignada a la máquina virtual
output "vm_public_ip" {
  description = "Dirección IP pública de la VM"
  value       = azurerm_public_ip.vm_ip.id
}

# Exporta el ID del Workspace de Log Analytics para integraciones o consultas
output "log_analytics_workspace_id" {
  description = "ID del Workspace de Log Analytics"
  value       = azurerm_log_analytics_workspace.log_analytics.id
}
