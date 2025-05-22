# Cliente Personas Service

Este microservicio en Spring Boot permite consultar productos de crédito de un cliente e iniciar una solicitud con validación, conectado a MySQL o Amazon RDS.

---

## 🚀 Características

- `GET /api/productos?clienteId=1`: consulta productos del cliente
- `POST /api/solicitar-producto`: registra solicitud y valida datos

---

## 🐳 Ejecución local con Docker y MySQL

```bash
docker compose up --build
```

Requiere Docker y Docker Compose.

---

## ☁️ Conexión a Amazon RDS

Para usar Amazon RDS en vez de MySQL local:

1. Crea una base de datos MySQL en RDS
2. Copia el endpoint y configura `.env`:

```env
DB_HOST=tu-endpoint-rds.us-east-1.rds.amazonaws.com
DB_PORT=3306
DB_NAME=creditodb
DB_USER=admin
DB_PASS=tu-clave-segura
```

3. Asegúrate de que el grupo de seguridad del RDS permita conexiones entrantes al puerto 3306 desde tu instancia EC2 o red.

---

## 🔐 IAM Role necesario (para EC2 con acceso a RDS)

Adjunta esta política al IAM Role de tu instancia EC2:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "rds:DescribeDBInstances",
        "rds:Connect",
        "rds:DescribeDBClusters"
      ],
      "Resource": "*"
    }
  ]
}
```

> Esto no reemplaza las reglas de red de seguridad del VPC (verifica que tu EC2 puede conectarse al RDS).

---

## 📦 Variables de entorno

El microservicio usa `.env` para la configuración de base de datos:

```env
DB_HOST=localhost
DB_PORT=3306
DB_NAME=creditodb
DB_USER=root
DB_PASS=root
```

---

## ✅ Requisitos

- Java 17
- Maven
- Docker
- MySQL local o Amazon RDS