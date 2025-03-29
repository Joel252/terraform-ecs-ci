# Terraform ECS-EC2 basic infrastructure

Este proyecto utiliza Terraform para desplegar una infraestructura en AWS que incluye:

- Una red VPC con subredes públicas y privadas.
- Un Application Load Balancer (ALB) para enrutar el tráfico.
- Instancias EC2 gestionadas por un Auto Scaling Group.
- Tareas ECS para ejecutar contenedores Docker.
- Configuración de un registro DNS en Route 53.

![architecture]()

> [!note]
> El proyecto esta hecho para actuar como una plantilla personalizable. Estableciendo los valores deseados en las variables; Las propiedades opcionales pueden ser retiradas borrando la propiedad del modulo; Los modulos se pueden omitir o reutilizar simplemente borrando o agregando los bloques en el archivo main.tf respectivamente.

## Requisitos Previos

- Terraform (versión >= 1.0.0).
- AWS CLI configurado con credenciales válidas (Si se ejecuta en local).

Configuración de AWS:

- Una cuenta de AWS con permisos para crear recursos como VPC, ALB, ECS, EC2, y Route 53.
- Un dominio registrado en Route 53 (si se usa el módulo **`route53`**).

## Variables Principales

A continuación, se describen las variables utilizadas en el proyecto:

| Variable | Descripción | Valor por defecto |
|----------|-------------|-------------------|
| `local.name` | Nombre base para los recursos. | "my-app" |
| `local.region` | Región de AWS donde se desplegarán los recursos. | "us-east-1" |
| `cidr_block` | Rango de direcciones IP para la VPC. | "10.0.0.0/16" |
| `public_subnets` | Subredes públicas. | ["10.0.0.0/24", "10.0.1.0/24"] |
| `private_subnets` | Subredes privadas. | ["10.0.2.0/24", "10.0.3.0/24"] |

## Usage

### In local

**Asegurate de modificar el archivo `backend.tf`** para usar `local` en lugar de `http`.

```shell
# Move into the base directory
cd terraform-ecs-ci

# Sets up Terraform
terraform init

# Previews actions
terraform plan

# Executes the Terraform run
terraform apply

# Destroy infrastructure (Only if necessary)
terraform destroy
```

En este caso el archivo `.tfstate` se alojara en el directorio del proyecto.

### Automated

El proyecto cuenta con una pipeline para facilitar el despliegue de la infraestructura. Basta con subir este proyecto en GitLab para su ejecución y seguir los siguientes pasos:

1. Crea un nuevo repositorio en GitLab basado en este template.
2. Configura las variables de GitLab CI/CD en Settings > CI/CD > Variables:
    - AWS_ACCESS_KEY_ID
    - AWS_SECRET_ACCESS_KEY
    - CI_REGISTRY_USER
    - CI_REGISTRY_PASSWORD

3. Realiza un commit en la rama main para que GitLab ejecute el pipeline automáticamente.
4. Verifica en AWS ECS que el servicio está corriendo con la imagen de GitLab Container Registry.

> [!note]
>
> - Asegúrate de que las políticas de IAM estén correctamente configuradas para permitir que ECS y EC2 accedan a los recursos necesarios.
> - Si usas imágenes privadas de ECR, verifica que el rol de ejecución de ECS tenga permisos para autenticarse con ECR.
>
> _En el caso de no especificar ningún rol, se crearan roles por defecto con estos permisos incluidos._

## Pipeline flow

- Validate: Validación de archivos de configuración de Terraform.
- Plan: Generación de un plan de ejecución para revisar cambios en la infraestructura.
- Apply: Aplicación de cambios en la infraestructura usando Terraform.
- Deploy: Despliegue de la imagen de la aplicación en los ambientes objetivo (desarrollo o producción).
- Destroy: Eliminación de recursos de infraestructura cuando sea necesario.

![pipeline flow]()

## Overview

![overview]()
