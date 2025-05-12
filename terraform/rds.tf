resource "aws_db_instance" "mysql_credito" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  name                 = var.db_name
  username             = var.db_username
  password             = var.db_password
  publicly_accessible  = true
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.credito_subnets.name
  vpc_security_group_ids = [aws_security_group.credito_db_sg.id]
}

resource "aws_db_subnet_group" "credito_subnets" {
  name       = "credito-subnet-group"
  subnet_ids = module.vpc.public_subnets
}

resource "aws_security_group" "credito_db_sg" {
  name   = "credito-db-sg"
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