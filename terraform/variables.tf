variable "aws_region" {
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "development"
}

variable "project_name" {
  type        = string
  default     = "the-bank-credito-solicitud"
}

variable "kms_key_alias_base" {
  description = "Base name for KMS key alias"
  type        = string
  default     = "eks/credito-cluster"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "Availability zones to deploy resources"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "ec2_instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
  default     = "t3.nano"
}

variable "ec2_ami" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-0953476d60561c955"
}

variable "db_instance_class" {
  description = "Instance class for RDS instance"
  type        = string
  default     = "db.t3.small"
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "creditodb"
}

variable "db_username" {
  description = "Username for the database"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "db_password" {
  description = "Password for the database"
  type        = string
  sensitive   = true
}

variable "db_port" {
  description = "Port for the database"
  type        = number
  default     = 3306
}

variable "api_gateway_name" {
  description = "Name of the API Gateway"
  type        = string
  default     = "credito-solicitud-api"
}

variable "lb_name" {
  description = "Name of the load balancer"
  type        = string
  default     = "credito-solicitud-lb"
}

variable "ec2_instance_count" {
  description = "Number of EC2 instances"
  type        = number
  default     = 2
}