variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_ami" {
  description = "AMI ID for EC2 instance"
  type        = string
  default     = "ami-08a52ddb321b32a8c"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for subnet"
  type        = string
  default     = "10.10.1.0/24"
}

variable "sg_description" {
  description = "Description for security group"
  type        = string
  default     = "Allow inbound SSH traffic"
}
