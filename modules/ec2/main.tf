# 1. Tạo IAM Role cho EC2
resource "aws_iam_role" "ec2_role" {
  name_prefix = "ec2-instance-role-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# 2. Tạo Instance Profile 
resource "aws_iam_instance_profile" "ec2_profile" {
  name_prefix = "ec2-instance-profile-"
  role = aws_iam_role.ec2_role.name
}

# 3.Public EC2 Instance
resource "aws_instance" "public_jump_host" {
  ami                    = var.ami_id
  instance_type          = "t3.micro"
  key_name               = var.key_name
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.public_ec2_sg_id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name 

  monitoring    = true
  ebs_optimized = true

  root_block_device {
    encrypted = true
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = { Name = "Public-Jump-Host" }
}

# 4. Private EC2 Instance
resource "aws_instance" "private_app_server" {
  ami                    = var.ami_id
  instance_type          = "t3.micro"
  key_name               = var.key_name
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.private_ec2_sg_id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name 

  monitoring    = true
  ebs_optimized = true

  root_block_device {
    encrypted = true
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = { Name = "Private-App-Server" }
}

output "public_ip_jump_host" {
  value = aws_instance.public_jump_host.public_ip
}

output "private_ip_app_server" {
  value = aws_instance.private_app_server.private_ip
}