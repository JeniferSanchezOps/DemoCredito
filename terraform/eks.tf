module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "credito-cluster"
  cluster_version = "1.27"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.public_subnets
  enable_irsa     = true
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