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