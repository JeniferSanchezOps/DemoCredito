# Demo de Provisión y Despliegue de Microservicio de Crédito

Este repositorio contiene la infraestructura y automatización necesarias para desplegar un microservicio de solicitudes de crédito utilizando:

- Terraform
- AWS EKS (Kubernetes)
- AWS RDS (MySQL)
- AWS KMS
- GitHub Actions

---

## 📁 Estructura del Proyecto

```
terraform/
├── eks.tf               # Módulo de clúster EKS con alias KMS dinámico
├── main.tf              # Módulo de red VPC
├── variables.tf         # Variables necesarias (región, DB, alias)
.github/
└── workflows/
    └── full-provision.yml  # Workflow CI/CD para provisión y despliegue
```

---

## 🚀 ¿Qué hace este proyecto?

1. Crea una VPC con subredes públicas
2. Provisiona un clúster EKS
3. Crea una instancia RDS (MySQL)
4. Despliega una aplicación Spring Boot en Kubernetes
5. Usa KMS para cifrado y CloudWatch para logs

---

## ✅ Requisitos

- Cuenta de AWS
- IAM user con permisos sobre: EKS, RDS, KMS, VPC, CloudWatch
- Secrets configurados en GitHub:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - `DB_PASSWORD`

---

## 🛠️ Uso

### 1. Subir a tu repositorio en GitHub

Clona este repo y haz push a tu cuenta.

### 2. Crear los secrets en GitHub

En tu repositorio:
```
Settings → Secrets → Actions
```

Agrega los siguientes:

| Name                | Valor                       |
|---------------------|-----------------------------|
| `AWS_ACCESS_KEY_ID` | Tu access key AWS           |
| `AWS_SECRET_ACCESS_KEY` | Tu secret key AWS     |
| `DB_PASSWORD`       | Password segura para RDS    |

---

### 3. Ejecutar el workflow

1. Ve a la pestaña **Actions**
2. Selecciona **"Full Provision and Deploy"**
3. Haz clic en **"Run workflow"**

---

### 4. Verificar el despliegue

Una vez finalice:

- Accede al EKS → carga balanceada
- Accede a tu microservicio en `http://<EXTERNAL-IP>:8080/solicitud`

---

## 👀 Observaciones

- El alias KMS se genera automáticamente usando `random_id` para evitar conflictos
- Las subredes y recursos usan nombres únicos por ejecución
- Se recomienda agregar un paso de `terraform destroy` para entornos temporales

---

## 📬 Soporte

Contacta a tu DevOps favorito o abre un issue si algo falla 🙌