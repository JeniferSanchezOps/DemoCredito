#!/bin/bash

echo "🔧 Instalando dependencias en EC2..."

# Actualizar paquetes
sudo apt-get update -y

# Instalar Docker
echo "📦 Instalando Docker..."
sudo apt-get install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker

# Instalar Docker Compose
echo "📦 Instalando Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verificar Docker
echo "✅ Docker instalado:"
docker --version

# Clonar repositorio si no existe
REPO_URL="https://github.com/TU_USUARIO/TU_REPO.git"
DEST_DIR="/home/ubuntu/cliente-personas"

if [ ! -d "$DEST_DIR" ]; then
    echo "📥 Clonando proyecto desde $REPO_URL"
    git clone $REPO_URL $DEST_DIR
fi

cd $DEST_DIR

# Verificar archivo .env con RDS
if [ ! -f ".env" ]; then
    echo "⚠️ No se encontró .env. Creando configuración base para RDS..."
    cat <<EOF > .env
DB_HOST=rds-endpoint.amazonaws.com
DB_PORT=3306
DB_NAME=creditodb
DB_USER=admin
DB_PASS=claveSuperSegura
EOF
    echo "⚠️ Por favor edita .env para colocar tu RDS real."
fi

# Construir imagen
echo "🐳 Construyendo imagen..."
docker build -t cliente-personas-service .

# Ejecutar
echo "🚀 Lanzando contenedor con configuración RDS..."
docker run --env-file .env -d -p 8080:8080 --name cliente-app cliente-personas-service

echo "🌐 Accede a: http://<EC2_PUBLIC_IP>:8080/api/productos?clienteId=1"