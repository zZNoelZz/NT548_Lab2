terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    http = {
      source = "hashicorp/http"
    }
  }
}

provider "aws" {
  region = var.region
}
# Lấy địa chỉ IP công cộng hiện tại của máy tính để giới hạn SSH
data "http" "my_ip" {
  url = "http://ipv4.icanhazip.com"
}
# Loại bỏ ký tự xuống dòng và thêm /32 để thành CIDR
locals {
  source_ip = "${chomp(data.http.my_ip.response_body)}/32"
}
# 1. VPC Module 
module "vpc" {
  source               = "./modules/vpc"
  region               = var.region
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidr   = "10.0.1.0/24"
  private_subnet_cidr  = "10.0.2.0/24"
}
# 2. Security Groups Module 
module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
  my_ip  = local.source_ip 
}

# 3. EC2 Module 
module "ec2" {
  source                 = "./modules/ec2"
  ami_id                 = var.ami_id
  key_name               = var.key_name
  public_subnet_id       = module.vpc.public_subnet_id
  private_subnet_id      = module.vpc.private_subnet_id
  public_ec2_sg_id       = module.security_groups.public_ec2_sg_id
  private_ec2_sg_id      = module.security_groups.private_ec2_sg_id
}