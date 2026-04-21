terraform {

  required_version = "1.14.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.41.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}

resource "aws_instance" "ec2_nginx" {
  ami           = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type = "t3.micro"
  key_name      = "ec2-instance"

  primary_network_interface {
    network_interface_id = aws_network_interface.ec2_nginx_interface.id
  }

  tags = {
    Name = "ec2-instance"
    app  = "nginx"
  }
}

resource "aws_vpc" "ec2_nginx_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "ec2-instance-vpc"
    app  = "nginx"
  }
}

resource "aws_subnet" "ec2_nginx_subnet" {
  vpc_id            = aws_vpc.ec2_nginx_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "ec2-instance-subnet"
    app  = "nginx"
  }
}

# Security Group para liberar HTTP, HTTPS e SSH
resource "aws_security_group" "ec2_nginx_sg" {
  name        = "ec2-nginx-sg"
  description = "Permite acesso HTTP, HTTPS e SSH"
  vpc_id      = aws_vpc.ec2_nginx_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-instance-sg"
    app  = "nginx"
  }
}

resource "aws_network_interface" "ec2_nginx_interface" {
  subnet_id       = aws_subnet.ec2_nginx_subnet.id
  private_ips     = ["172.16.10.100"]
  security_groups = [aws_security_group.ec2_nginx_sg.id]

  tags = {
    Name = "ec2-instance-network-interface"
    app  = "nginx"
  }
}

# Internet Gateway para acesso externo
resource "aws_internet_gateway" "ec2_nginx_igw" {
  vpc_id = aws_vpc.ec2_nginx_vpc.id

  tags = {
    Name = "ec2-instance-igw"
    app  = "nginx"
  }
}

# Tabela de rotas pública
resource "aws_route_table" "ec2_nginx_public_rt" {
  vpc_id = aws_vpc.ec2_nginx_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ec2_nginx_igw.id
  }

  tags = {
    Name = "ec2-instance-public-rt"
    app  = "nginx"
  }
}

# Associação da tabela de rotas pública à subnet
resource "aws_route_table_association" "ec2_nginx_public_assoc" {
  subnet_id      = aws_subnet.ec2_nginx_subnet.id
  route_table_id = aws_route_table.ec2_nginx_public_rt.id
}

# # Associação de IP público à interface de rede
# resource "aws_eip" "ec2_nginx_eip" {
#   network_interface         = aws_network_interface.ec2_nginx_interface.id
#   associate_with_private_ip = "172.16.10.100"

#   depends_on = [aws_instance.ec2_nginx]

#   tags = {
#     Name = "ec2-instance-eip"
#     app  = "nginx"
#   }
# }

