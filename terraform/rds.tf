resource "random_id" "suffix1" {
  byte_length = 4
}

resource "aws_db_subnet_group" "credito_subnets" {
  name       = "credito-subnet-group-${random_id.suffix1.hex}"
  subnet_ids = module.vpc.public_subnets
}

resource "aws_db_instance" "mysql_credito" {
  identifier           = "credito-rds-${random_id.suffix1.hex}"
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  publicly_accessible  = true
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.credito_subnets.name
  vpc_security_group_ids = [aws_security_group.credito_db_sg.id]
}


resource "aws_security_group" "credito_db_sg" {
  name   = "credito-db-sg${random_id.suffix1.hex}"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}