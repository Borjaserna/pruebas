# Proyecto Terraform: Infraestructura de Seguridad y Monitoreo en Azure

Este proyecto proporciona una solución integral para desplegar y gestionar una infraestructura segura y monitorizada en Microsoft Azure utilizando Terraform. Está diseñado como una base para entornos de pruebas, desarrollo, demostraciones o como punto de partida para arquitecturas más complejas en la nube.

## Descripción General
La infraestructura creada por este proyecto está orientada a la protección, visibilidad y control de una máquina virtual Linux en Azure. Se implementan buenas prácticas de segmentación de red, monitoreo centralizado y alertas automatizadas para facilitar la administración y la respuesta ante incidentes.

### Objetivos principales:
- **Seguridad**: Aislar la máquina virtual en una subred privada y controlar el acceso mediante recursos de red.
- **Monitoreo**: Recopilar métricas y logs de actividad para detectar cambios y posibles amenazas.
- **Automatización**: Permitir el despliegue reproducible y controlado de la infraestructura mediante código.

## Recursos implementados
- **Grupo de recursos**: Un contenedor lógico que agrupa todos los recursos relacionados, facilitando la gestión y el ciclo de vida.
- **Red virtual (VNet) y subred privada**: Proporcionan aislamiento de red y segmentación para la máquina virtual, mejorando la seguridad.
- **IP pública e interfaz de red**: Permiten la conectividad externa controlada y la asignación de red a la VM.
- **Máquina virtual Linux (Ubuntu)**: Un entorno de servidor listo para pruebas, desarrollo o despliegue de aplicaciones.
- **Log Analytics Workspace**: Centraliza la recopilación y análisis de logs y métricas de los recursos de Azure.
- **Alertas de actividad y grupo de acción**: Monitorizan cambios administrativos en la VM y envían notificaciones por correo electrónico a los administradores.
- **Dashboard de Azure Monitor**: Ofrece una visualización en tiempo real del estado y rendimiento de la máquina virtual, facilitando la supervisión proactiva.

## Automatización con GitHub Actions
El proyecto está preparado para integrarse con GitHub Actions, permitiendo la automatización del despliegue de la infraestructura como parte de un flujo CI/CD. Esto significa que puedes definir workflows en el repositorio para que, cada vez que se realicen cambios en los archivos de Terraform, se ejecuten automáticamente los comandos de `terraform init`, `plan` y `apply` (según la configuración y permisos), asegurando despliegues consistentes y auditables.

### Ventajas de usar GitHub Actions:
- **Despliegue automatizado**: No es necesario ejecutar manualmente los comandos en local, todo el proceso puede ser gestionado desde la nube.
- **Auditoría y trazabilidad**: Cada cambio queda registrado en el historial de acciones del repositorio.
- **Integración continua**: Puedes combinar pruebas, validaciones y despliegues en un solo flujo de trabajo.

> **Nota:** Para utilizar GitHub Actions con Terraform y Azure, deberás agregar un archivo de workflow en `.github/workflows/` y configurar los secretos necesarios (como credenciales de Azure) en el repositorio.

## Estructura de archivos
- `main.tf`: Define todos los recursos de Azure a desplegar, incluyendo red, VM, monitoreo y alertas.
- `variables.tf`: Contiene las variables configurables del proyecto, como ubicación, nombre del grupo de recursos y tamaño de la VM.
- `outputs.tf`: Exporta valores útiles tras el despliegue, como el ID de la red, la IP pública de la VM y el ID del workspace de logs.
- `providers.tf`: Configura el proveedor de AzureRM necesario para interactuar con la nube de Azure.

## Instrucciones de uso
1. **Clona este repositorio** y navega al directorio `project`:
   ```powershell
   git clone <URL-del-repositorio>
   cd pruebas\project
   ```
2. **Inicializa Terraform** para descargar los proveedores necesarios:
   ```powershell
   terraform init
   ```
3. **Revisa el plan de despliegue** para ver los recursos que se crearán:
   ```powershell
   terraform plan
   ```
4. **Aplica la infraestructura** en tu suscripción de Azure:
   ```powershell
   terraform apply
   ```
5. **Confirma los valores de las variables** si es necesario, o utiliza los valores por defecto definidos en `variables.tf`.

## Requisitos previos
- Cuenta activa en Microsoft Azure con permisos para crear recursos.
- [Terraform](https://www.terraform.io/downloads.html) instalado en tu equipo.
- Acceso a la línea de comandos (PowerShell, CMD o terminal compatible).

## Personalización y buenas prácticas
- **Contraseña de la VM**: Cambia la contraseña por defecto de la máquina virtual antes de usarla en entornos productivos.
- **Reglas de red**: Ajusta las reglas de acceso y segmentación según las necesidades de seguridad de tu organización.
- **Alertas y notificaciones**: Modifica los destinatarios y condiciones de las alertas para adaptarlas a tus flujos de trabajo.
- **Escalabilidad**: Puedes ampliar este proyecto agregando más recursos, como balanceadores de carga, bases de datos o configuraciones de alta disponibilidad.

## Beneficios de usar Terraform en Azure
- **Infraestructura como código (IaC)**: Permite versionar, auditar y reutilizar la infraestructura.
- **Despliegue reproducible**: Garantiza que los entornos sean consistentes y fáciles de replicar.
- **Automatización**: Reduce errores manuales y acelera la provisión de recursos.

## Recursos útiles
- [Documentación oficial de Terraform](https://www.terraform.io/docs)
- [Proveedor AzureRM para Terraform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Portal de Azure](https://portal.azure.com)

---
Este proyecto es ideal para quienes desean aprender, experimentar o implementar prácticas de seguridad y monitoreo en Azure de manera automatizada y controlada. Puedes utilizarlo como base para proyectos más grandes o adaptarlo a tus necesidades específicas.
