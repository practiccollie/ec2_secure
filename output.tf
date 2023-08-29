output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.ec2_name.public_ip
}

output "public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.ec2_name.public_dns
}

output "private_ip" {
  description = "Private IP of the EC2 instance"
  value       = aws_instance.ec2_name.private_ip
}
