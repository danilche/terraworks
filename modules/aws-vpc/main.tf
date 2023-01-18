resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.vpc_name}-IGW"
  }
}

resource "aws_route_table" "private_route_tables" {
  count = length(var.private_subnets)
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.vpc_name}-PRT"
  }
}

resource "aws_route_table" "public_route_tables" {
  count = length(var.public_subnets)
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.vpc_name}-PRT"
  }
}

resource "aws_subnet" "public_subnets" {
  count = "${local.env_vars.locals.environment}" == "prod" ? length(var.public_subnets) : 1
  vpc_id = aws_vpc.vpc.id
  cidr_block = "${local.env_vars.locals.environment}" == "prod" ? var.public_subnets[count.index] : var.public_subnets[0]
  availability_zone = "${local.env_vars.locals.environment}" == "prod" ? var.azs[count.index] : var.azs[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_name}-PSN"
  }
}

resource "aws_subnet" "private_subnets" {
  count = length(var.private_subnets)
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.vpc_name}-PSN"
  }
}

resource "aws_nat_gateway" "nat_gws" {
  count = length(var.public_subnets)
  allocation_id = aws_eip.nat_eips[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id
  tags = {
    Name = "${var.vpc_name}-NGW"
  }
}

resource "aws_eip" "nat_eips" {
  count = length(var.public_subnets)
  vpc = true
  tags = {
    Name = "${var.vpc_name}-EIP"
  }
}

resource "aws_route_table_association" "private_route_table_associations" {
  count = length(var.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_tables[count.index].id
}

resource "aws_route_table_association" "public_route_table_associations" {
  count = length(var.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_tables[count.index].id
}