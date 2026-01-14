variable "region" {
  description = "AWS region to deploy"
  type        = string
  default     = "ap-southeast-1" 
}
variable "ami_id" {
  description = "AMI ID cho EC2 (Ubuntu 24.04 LTS)"
  type        = string
  default     = "ami-00d8fc944fb171e29" 
}

variable "key_name" {
  description = "Tên Key Pair đã có trên AWS để SSH vào EC2"
  type        = string
  default     = "key" 
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the Public Subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the Private Subnet"
  type        = string
  default     = "10.0.2.0/24"
}