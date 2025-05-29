# Proyecto Terraform: Infraestructura de Seguridad y Monitoreo en Azure

Este proyecto implementa una infraestructura básica en Azure utilizando Terraform, enfocada en la seguridad y el monitoreo de una máquina virtual Linux. Incluye los siguientes recursos principales:

- **Grupo de recursos**: Contenedor lógico para todos los recursos de Azure del proyecto.
- **Red virtual y subred privada**: Segmentación de red para aislar la máquina virtual.
- **IP pública e interfaz de red**: Permite la conectividad y asignación de red a la VM.
- **Máquina virtual Linux**: Despliegue de una VM Ubuntu lista para pruebas o aplicaciones.
- **Log Analytics Workspace**: Centraliza la recopilación de métricas y logs de los recursos.
- **Alertas de actividad y grupo de acción**: Monitoriza cambios administrativos y envía notificaciones por correo
- **Dashboard de Azure Monitor**: Visualiza el rendimiento y estado de la VM en tiempo real.

## Archivos principales
- `main.tf`: Define todos los recursos de Azure a desplegar.
- `variables.tf`: Variables configurables como ubicación, nombre del grupo de recursos y tamaño de la VM.
- `outputs.tf`: Exporta valores útiles como el ID de la red, IP pública y el ID del workspace de logs.
- `providers.tf`: Configuración del proveedor de AzureRM para Terraform.

## Uso rápido
1. Clona este repositorio y navega al directorio `project`.
2. Inicializa Terraform:
   ```powershell
   terraform init
   ```
3. Revisa y aplica la infraestructura:
   ```powershell
   terraform apply
   ```
4. Ingresa los valores de variables si es necesario o usa los valores por defecto.

## Requisitos
- Tener una cuenta de Azure activa.
- Instalar [Terraform](https://www.terraform.io/downloads.html).
- Tener permisos para crear recursos en Azure.

## Notas de seguridad
- Cambia la contraseña por defecto de la VM antes de usar en producción.
- Ajusta las reglas de red y acceso según tus necesidades de seguridad.

---
Este proyecto es una base para entornos de pruebas, demos o como punto de partida para soluciones más avanzadas en Azure.
