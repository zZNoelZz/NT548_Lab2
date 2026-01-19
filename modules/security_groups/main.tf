# 1. Public EC2 Security Group (Jump Host)
resource "aws_security_group" "public_ec2" {
  name        = "Public-EC2-SG"
  description = "Allow SSH from user IP"
  vpc_id      = var.vpc_id

  # Ingress: Cho phép SSH từ IP của người dùng
  ingress {
    description = "SSH from My IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip] 
  }

  # Egress: Cho phép lưu lượng từ 1 số port phổ biến ra ngoài
  egress {
    description = "Allow HTTP outbound"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow HTTPS outbound"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. Private EC2 Security Group (App Server)
resource "aws_security_group" "private_ec2" {
  name        = "Private-EC2-SG"
  description = "Allow connection from Jump Host SG"
  vpc_id      = var.vpc_id

  # Ingress: Cho phép SSH từ Public EC2 SG
  ingress {
    description     = "SSH from Jump Host"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_ec2.id] 
  }

  # Egress: Cho phép lưu lượng từ 1 số port phổ biến ra ngoài (sẽ sử dụng NAT Gateway)
  egress {
    description = "Allow HTTP outbound via NAT"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow HTTPS outbound via NAT"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ec2_sg_id" {
  description = "ID Security Group cho Public EC2"
  value       = aws_security_group.public_ec2.id
}

output "private_ec2_sg_id" {
  description = "ID Security Group cho Private EC2"
  value       = aws_security_group.private_ec2.id
}