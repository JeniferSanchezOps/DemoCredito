variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "kms_key_alias_base" {
  description = "Base name for KMS key alias"
  type        = string
  default     = "eks/credito-cluster"
}

variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}
variable "db_username" {
  description = "Usuario principal de la base de datos"
  type        = string
  default     = "admin"
}

variable "db_name" {
  description = "Nombre inicial de la base de datos"
  type        = string
  default     = "creditodb"
}