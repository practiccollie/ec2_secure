# Define the AWS provider configuration
provider "aws" {
  region = var.region
}

# Generate a TLS private key
resource "tls_private_key" "createkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create an AWS key pair from the generated private key
resource "aws_key_pair" "generated_key" {
  key_name   = "practiccollie_ec2_key"
  public_key = tls_private_key.createkey.public_key_openssh
}

# Save the generated private key to a file
resource "null_resource" "savekey"  {
  depends_on = [
    tls_private_key.createkey,
  ]
  
  provisioner "local-exec" {
    command = "echo '${tls_private_key.createkey.private_key_pem}' > practiccollie_ec2_key.pem"
  }
}

# Create a Virtual Private Cloud (VPC)
resource "aws_vpc" "vpc_name" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "practiccollie-vpc"
  }
}

# Create a subnet within the VPC
resource "aws_subnet" "subnet_name" {
  vpc_id     = aws_vpc.vpc_name.id
  cidr_block = var.subnet_cidr

  tags = {
    Name = "practiccollie-subnet"
  }
}

# Create an internet gateway for the VPC
resource "aws_internet_gateway" "igw_name" {
  vpc_id = aws_vpc.vpc_name.id

  tags = {
    Name = "practiccollie-igw"
  }
}

# Create a route table for the VPC
resource "aws_route_table" "route_name" {
  vpc_id = aws_vpc.vpc_name.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_name.id
  }

  tags = {
    Name = "practiccollie-rt"
  }
}

# Associate the subnet with the route table
resource "aws_route_table_association" "rt_association" {
  subnet_id      = aws_subnet.subnet_name.id
  route_table_id = aws_route_table.route_name.id
}

# Create a security group for your EC2 instance
resource "aws_security_group" "sg_name" {
  name        = "practiccollie-sg"
  description = var.sg_description
  vpc_id      = aws_vpc.vpc_name.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "practiccollie-sg"
  }
}

# Create an EC2 instance
resource "aws_instance" "ec2_name" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  key_name      = "practiccollie_ec2_key"
  user_data = "${file("installations.sh")}"
  subnet_id     = aws_subnet.subnet_name.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg_name.id]

  tags = {
    Name = "practiccollie-ec2"
  }
}

