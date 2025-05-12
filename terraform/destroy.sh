#!/bin/bash

set -e

echo "🔐 Cargando configuración de Terraform..."

cd terraform

echo "🧹 Ejecutando 'terraform destroy'..."
terraform init
terraform destroy -auto-approve -var="db_password=${TF_VAR_db_password}" -var="kms_key_alias_base=${TF_VAR_kms_key_alias_base:-eks/credito-cluster}"

echo "✅ Infraestructura eliminada correctamente."