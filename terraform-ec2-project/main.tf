provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "credito_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "credito_subnet" {
  vpc_id                  = aws_vpc.credito_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "credito_gw" {
  vpc_id = aws_vpc.credito_vpc.id
}

resource "aws_route_table" "credito_route_table" {
  vpc_id = aws_vpc.credito_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.credito_gw.id
  }
}

resource "aws_route_table_association" "credito_subnet_assoc" {
  subnet_id      = aws_subnet.credito_subnet.id
  route_table_id = aws_route_table.credito_route_table.id
}

resource "aws_security_group" "credito_sg" {
  name        = "credito-sg"
  description = "Permite acceso a puerto 22 y 8080"
  vpc_id      = aws_vpc.credito_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP App"
    from_port   = 8080
    to_port     = 8080
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

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "credito_key" {
  key_name   = "credito-ssh-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_instance" "credito_ec2" {
  ami           = "ami-0c2b8ca1dad447f8a"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.credito_subnet.id
  key_name      = aws_key_pair.credito_key.key_name
  vpc_security_group_ids = [aws_security_group.credito_sg.id]

  tags = {
    Name = "credito-ec2"
  }

  associate_public_ip_address = true

  provisioner "remote-exec" {
    inline = [
      "sudo yum install docker -y",
      "sudo systemctl start docker",
      "sudo usermod -aG docker ec2-user"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = tls_private_key.ssh_key.private_key_pem
      host        = self.public_ip
    }
  }
}

output "ec2_public_ip" {
  value = aws_instance.credito_ec2.public_ip
}

output "ssh_private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}