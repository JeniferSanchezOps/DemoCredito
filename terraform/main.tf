# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "5.1.2"

#   name = "credito-vpc"
#   cidr = "10.0.0.0/16"

#   azs             = ["us-east-1a", "us-east-1b"]
#   public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]

#   enable_dns_hostnames = true
#   enable_dns_support   = true
# } 



terraform {
  backend "s3" {
    bucket = "the-bank-arch-experiment-tfstate"
    key    = "tf/state"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.48"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "The Bank architecture experiment"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}