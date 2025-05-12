module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.8.4"

  cluster_name    = "credito-cluster"
  cluster_version = "1.27"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.public_subnets

  enable_irsa     = true

  # Alias KMS dinámico para evitar errores por alias ya existentes
  create_kms_key         = true
  kms_key_aliases        = ["alias/eks/credito-cluster-${terraform.workspace}"]
  kms_key_deletion_window_in_days = 7
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "credito-vpc"
  cidr   = "10.0.0.0/16"
  azs    = ["us-east-1a", "us-east-1b"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

resource "kubernetes_namespace" "creditos" {
  metadata {
    name = "creditospersonas"
  }
}

