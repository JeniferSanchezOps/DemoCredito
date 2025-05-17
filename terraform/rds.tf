# resource "random_id" "suffix1" {
#   byte_length = 4
# }

# resource "aws_db_subnet_group" "credito_subnets" {
#   name       = "credito-subnet-group-${random_id.suffix1.hex}"
#   subnet_ids = module.vpc.public_subnets
# }

# resource "aws_db_instance" "mysql_credito" {
#   identifier           = "credito-rds-${random_id.suffix1.hex}"
#   allocated_storage    = 20
#   engine               = "mysql"
#   engine_version       = "8.0"
#   instance_class       = "db.t3.micro"
#   db_name              = var.db_name
#   username             = var.db_username
#   password             = var.db_password
#   publicly_accessible  = true
#   skip_final_snapshot  = true
#   db_subnet_group_name = aws_db_subnet_group.credito_subnets.name
#   vpc_security_group_ids = [aws_security_group.credito_db_sg.id]
# }


# resource "aws_security_group" "credito_db_sg" {
#   name   = "credito-db-sg${random_id.suffix1.hex}"
#   vpc_id = module.vpc.vpc_id

#   ingress {
#     from_port   = 3306
#     to_port     = 3306
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }



# Security Group for RDS
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg"
  description = "Security group for RDS MySQL instance"
  vpc_id      = aws_vpc.main.id

  # Allow MySQL traffic from EC2 instances
  ingress {
    description     = "MySQL from EC2 instances"
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
  }

  # Deny all outbound traffic by default
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}

# DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

# KMS Key for RDS encryption
resource "aws_kms_key" "rds" {
  description             = "KMS key for RDS encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name = "${var.project_name}-rds-kms-key"
  }
}

# RDS MySQL Instance
resource "aws_db_instance" "mysql" {
  identifier             = "${var.project_name}-mysql"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.db_instance_class
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  allocated_storage      = 10
  max_allocated_storage  = 100
  storage_type           = "gp2"
  storage_encrypted      = true
  kms_key_id             = aws_kms_key.rds.arn
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  multi_az               = true
  publicly_accessible    = false
  skip_final_snapshot    = true
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "mon:04:00-mon:05:00"
  parameter_group_name   = "default.mysql8.0"

  tags = {
    Name = "${var.project_name}-mysql"
  }
}

# CloudWatch Log Group for RDS
resource "aws_cloudwatch_log_group" "rds" {
  name              = "/aws/rds/instance/${aws_db_instance.mysql.identifier}/mysql"
  retention_in_days = 7

  tags = {
    Name = "${var.project_name}-rds-logs"
  }
}