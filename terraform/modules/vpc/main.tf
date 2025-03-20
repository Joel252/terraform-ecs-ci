data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  # Calculate the suffix for each AZ (e.g., "a", "b", "c")
  az_suffixes = [
    for az in data.aws_availability_zones.available.names :
    substr(az, -1, 1)
  ]
}

############################
# VPC
############################

resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = format("%s-network", var.name)
  }
}

############################
# Internet Gateway
############################

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = format("%s-internet", var.name)
  }
}

############################
# Subnets
############################

resource "aws_subnet" "public" {
  count = var.num_az_to_use

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = format("%s-dmz-%s", var.name, local.az_suffixes[count.index])
  }
}

resource "aws_subnet" "private" {
  count = var.create_private_subnets ? var.num_az_to_use : 0

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, count.index + var.num_az_to_use)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = format("%s-lan-%s", var.name, local.az_suffixes[count.index])
  }
}

############################
# Nat Gateway
############################

resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? var.num_az_to_use : 0

  domain = "vpc"

  tags = {
    Name = format("%s-eip-nat-%s", var.name, local.az_suffixes[count.index])
  }
}

resource "aws_nat_gateway" "nat" {
  count = var.enable_nat_gateway ? var.num_az_to_use : 0

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = format("%s-nat-%s", var.name, local.az_suffixes[count.index])
  }
}

############################
# Route Tables
############################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = format("%s-public-routes", var.name)
  }
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count = length(aws_subnet.private)

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }

  tags = {
    Name = format("%s-private-routes-%s", var.name, local.az_suffixes[count.index])
  }
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private[*].id

  subnet_id      = each.value
  route_table_id = aws_route_table.private[each.key].id
}
