terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

# Provedor da AWS
provider "aws" {
  region = "us-east-1"
}

# Cria um Security Group para a instância EC2 (permite SSH e HTTP)
resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Permitir SSH e HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permitir SSH de qualquer IP
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permitir HTTP de qualquer IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Permitir todo o tráfego de saída
  }
}

# Cria uma instância EC2
resource "aws_instance" "my_ec2_instance" {
  ami           = "ami-0e86e20dae9224db8"  # AMI Ubuntu 20.04 para us-east-1
  instance_type = "t2.micro"

  # Referência para a chave SSH e o Security Group
  key_name      = "vockey"
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]

  tags = {
    Name = "todolist"  # Nome da instância
  }

  # Pausa de 30 segundos para garantir que a instância está pronta
  provisioner "local-exec" {
    command = "sleep 30"
  }
}

# Cria uma instância RDS PostgreSQL
resource "aws_db_instance" "my_postgresql" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "13.4"
  instance_class       = "db.t2.micro"
  name                 = "todolist_db"
  username             = "admin"
  password             = "password123"
  publicly_accessible  = true
  skip_final_snapshot  = true

  # VPC Security Group para o RDS (mesmo Security Group usado pela instância EC2)
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]

  tags = {
    Name = "todolist"
  }
}

# Output para mostrar o endereço público da instância EC2
output "ec2_public_ip" {
  description = "Endereço IP público da instância EC2"
  value       = aws_instance.my_ec2_instance.public_ip
}

# Output para mostrar o endpoint da instância RDS PostgreSQL
output "rds_endpoint" {
  description = "Endpoint da instância RDS PostgreSQL"
  value       = aws_db_instance.my_postgresql.endpoint
}

