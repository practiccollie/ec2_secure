# ec2_secure

This **ec2_secure** script allows you to create an EC2 instance in AWS. Below is a walkthrough of the script's components and how to use it (free-Tier dont worry :grin:).


## Script Components

- **AWS Provider Configuration:** The AWS provider configuration is set to the region specified in the `var.region` variable.
- **TLS Private Key Generation:** This script generates a 4096-bit RSA private key using the `tls_private_key` resource. The private key is used to create an AWS key pair.
- **AWS Key Pair:** An AWS key pair is created using the generated private key. The public key is extracted from the private key and stored for authentication.
- **Saving the Private Key localy:** The generated private key is saved to a file named `practiccollie_ec2_key.pem` using the `null_resource` and `local-exec` provisioner.
- **VPC Creation:** The script creates a VPC with the specified CIDR block. DNS support and hostnames are enabled for the VPC.
- **Subnet Creation:** A subnet is created within the VPC using the specified CIDR block.
- **Internet Gateway:** An internet gateway is created and associated with the VPC.
- **Route Table:** A route table is created for the VPC with a default route pointing to the internet gateway.
- **Subnet Association:** The subnet is associated with the route table, ensuring proper routing.
- **Security Group:** A security group is created to control inbound and outbound traffic for the EC2 instance. It allows incoming traffic on ports 22 (SSH) and 80 (HTTP), and all outbound traffic.
- **EC2 Instance:** An EC2 instance is provisioned using the specified AMI and instance type. The instance is associated with the created subnet and security group. The user data script (`installations.sh`) is executed on instance launch.

## Usage Instructions

1. Make sure you have [Terraform](https://www.terraform.io/downloads.html) installed on your machine.
2. Update the `variables.tf` file to set your desired values for `region`, `vpc_cidr`, `subnet_cidr`, `instance_ami`, and `instance_type`.
3. Ensure that your AWS credentials are configured using environment variables or AWS configuration files.
4. Create a script named `installations.sh` in the same directory with any additional setup you want to perform on the EC2 instance.
5. Navigate to the directory containing this README and the script files.
6. Open a terminal and run the following commands:
   
```
terraform init
terraform apply --auto-approve
```
