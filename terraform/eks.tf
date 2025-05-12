resource "random_id" "suffix" {
  byte_length = 4
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"

  cluster_name    = "credito-cluster-${random_id.suffix.hex}"
  cluster_version = "1.27"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.public_subnets

  enable_irsa     = true
  create_kms_key  = true
  kms_key_aliases = ["eks/credito-cluster-${random_id.suffix.hex}"]
}