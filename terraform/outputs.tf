output "rds_endpoint" {
  value = aws_db_instance.mysql_credito.endpoint
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}