
resource "aws_vpc" "main_vpc" {
  cidr_block = var.cidr_block
  tags       = {
    Name = "Main VPC - ${var.owner}"
  }
}

resource "aws_subnet" "public_subnet_1" {
  cidr_block        = cidrsubnet(var.cidr_block, 8, 1)
  vpc_id            = aws_vpc.main_vpc.id
  availability_zone = var.availability_zones[0]
  tags              = {
    Name = "Public Subnet 1 - ${var.owner}"
    Type = "Public"
  }
}


resource "aws_subnet" "public_subnet_2" {
  cidr_block        = cidrsubnet(var.cidr_block, 8, 2)
  vpc_id            = aws_vpc.main_vpc.id
  availability_zone = var.availability_zones[1]
  tags              = {
    Name = "Public Subnet 2 - ${var.owner}"
    Type = "Public"
  }
}

resource "aws_subnet" "private_subnet_1" {
  cidr_block        = cidrsubnet(var.cidr_block, 8, 3)
  vpc_id            = aws_vpc.main_vpc.id
  availability_zone = var.availability_zones[0]
  tags              = {
    Name = "Private Subnet 1 - ${var.owner}"
    Type = "Public"
  }
}


resource "aws_subnet" "private_subnet_2" {
  cidr_block        = cidrsubnet(var.cidr_block, 8, 4)
  vpc_id            = aws_vpc.main_vpc.id
  availability_zone = var.availability_zones[1]
  tags              = {
    Name = "Private Subnet 1 - ${var.owner}"
    Type = "Public"
  }
}

resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags   = {
    Name = "Internet Gateway for ${aws_vpc.main_vpc.id} - ${var.owner}"
  }
}

resource "aws_eip" "nat_gw_eip" {
  vpc  = true
  tags = {
    Name = "Eip for Nat GW - ${var.owner}"
  }
}

resource "aws_nat_gateway" "vpc_nat_gw" {
  subnet_id     = aws_subnet.public_subnet_1.id
  allocation_id = aws_eip.nat_gw_eip.id
  tags          = {
    Name = "Nat Gateway for ${aws_vpc.main_vpc.id} - ${var.owner}"
  }
  depends_on    = [aws_internet_gateway.vpc_igw]
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw.id
  }
  tags   = {
    Name = "Route table for public subnet - ${var.owner}"
  }
}


resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.vpc_nat_gw.id
  }
  tags   = {
    Name = "Route table for private subnet - ${var.owner}"
  }
}

resource "aws_route_table_association" "rt_association_for_public_subnet_1" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet_1.id
}

resource "aws_route_table_association" "rt_association_for_public_subnet_2" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet_2.id
}


resource "aws_route_table_association" "rt_association_for_private_subnet_1" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnet_1.id
}

resource "aws_route_table_association" "rt_association_for_private_subnet_2" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnet_2.id
}
