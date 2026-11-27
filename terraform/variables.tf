variable "aws_region" {
  description = "AWS region where the infrastructure will be created"
  type        = string
  default     = "ap-south-1"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance (leave empty to use latest Amazon Linux 2023)"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of an existing EC2 key pair (created in AWS console) used for SSH"
  type        = string
}

variable "ssh_cidr" {
  description = "CIDR allowed to SSH. Use your public IP/32 for safety"
  type        = string
  default     = "0.0.0.0/0"
}
