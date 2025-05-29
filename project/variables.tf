# Variable para definir el nombre del grupo de recursos en Azure
variable "resource_group_name" {
  description = "Nombre del grupo de recursos en Azure"
  type        = string
  default     = "rg-security-monitoring"
}

# Variable para definir la ubicación donde se desplegarán los recursos
variable "location" {
  description = "Ubicación del despliegue"
  type        = string
  default     = "East US"
}

# Variable para definir el tamaño de la máquina virtual a desplegar
variable "vm_size" {
  description = "Tamaño de la máquina virtual"
  type        = string
  default     = "Standard_DS1_v2"
}
