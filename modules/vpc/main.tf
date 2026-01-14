# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "Main-VPC" }
}
# Internet Gateway (IGW)
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "Main-IGW" }
}

# Elastic IP (EIP) cho NAT Gateway
resource "aws_eip" "nat" {
 
  tags = { Name = "NAT-EIP" }
}

# Public Subnet (Đặt NAT Gateway và Jump Host)
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true # Bật Public IP cho Public Subnet
  availability_zone       = "${var.region}a"
  tags = { Name = "Public-Subnet" }
}

# Private Subnet (Đặt App Server)
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "${var.region}a"
  tags = { Name = "Private-Subnet" }
}

# NAT Gateway (Đặt trong Public Subnet)
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
  depends_on    = [aws_internet_gateway.main]
  tags = { Name = "Main-NAT-Gateway" }
}
# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "Public-RT" }
}

# Tuyến đường ra Internet qua IGW
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# Gán Public Subnet với Public Route Table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "Private-RT" }
}
# Tuyến đường ra Internet qua NAT Gateway
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}

# Gán Private Subnet với Private Route Table
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}