# 1. Public EC2 Instance (Jump Host/Bastion Host)
resource "aws_instance" "public_jump_host" {
  ami           = var.ami_id
  instance_type = "t3.micro"
  key_name      = var.key_name
  subnet_id     = var.public_subnet_id
  vpc_security_group_ids = [var.public_ec2_sg_id]

  tags = { Name = "Public-Jump-Host" }
}

# 2. Private EC2 Instance (App Server)
resource "aws_instance" "private_app_server" {
  ami           = var.ami_id
  instance_type = "t3.micro"
  key_name      = var.key_name
  subnet_id     = var.private_subnet_id
  vpc_security_group_ids = [var.private_ec2_sg_id]

  tags = { Name = "Private-App-Server" }
}

output "public_ip_jump_host" {
  value = aws_instance.public_jump_host.public_ip
}

output "private_ip_app_server" {
  value = aws_instance.private_app_server.private_ip
}