variable "resource_group_name" {
  description = "Nombre del grupo de recursos en Azure"
  type        = string
  default     = "rg-security-monitoring"
}

variable "location" {
  description = "Ubicación del despliegue"
  type        = string
  default     = "East US"
}

variable "vm_size" {
  description = "Tamaño de la máquina virtual"
  type        = string
  default     = "Standard_DS1_v2"
}
