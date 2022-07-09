# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = var.tags
}

# INTERNET GATEWAY
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = var.tags
}

# DATA SUBNET
data "aws_availability_zones" "available" {}

# PUBLIC SUBNET
resource "aws_subnet" "public_subnets" {
  count                   = var.vpc_public_subnet_count
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = var.tags
}

# PRIVATE SUBNET
resource "aws_subnet" "private_subnets" {
  count                   = var.vpc_private_subnet_count
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, count.index + 3)
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = var.map_public_ip_on_launch_1
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = var.tags
}

# PUBLIC ROUTE TABLE 
resource "aws_route_table" "public_rta" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = var.tags
}

# PUBLIC ROUTE TABLE SUBNET ASSOCIATION
resource "aws_route_table_association" "public_rta_subnets" {
  count          = var.vpc_public_subnet_count
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rta.id
}

# WEB SERVER SECURITY GROUP
resource "aws_security_group" "apache_sg" {
  name        = "apache_sg"
  description = "Allow ssh and http inboubd trafic"
  vpc_id      = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = var.tags
}

# INSTANCES 

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "apache_http" {
  count                  = var.instance_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnets[(count.index % var.vpc_public_subnet_count)].id
  vpc_security_group_ids = [aws_security_group.apache_sg.id]
  key_name               = aws_key_pair.this.id


  user_data = <<EOF
#! /bin/bash
sudo apt-get update -y
sudo apt-get install apache2 -y
sudo systemctl start apache2
echo "dhiraj here" > /var/www/html/index.html
sudo systemctl restart apache2
EOF

  tags = var.tags

}

# KEY PAIR
resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = "ohio_tf_key"
  public_key = tls_private_key.this.public_key_openssh
}