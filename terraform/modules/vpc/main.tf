############################
# VPC
############################
# The main VPC resource. DNS support and hostnames are enabled to allow
# resources within the VPC to resolve internal and external DNS names.
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
# Public subnets are configured to assign public IPs to instances automatically.
# These subnets are typically used for resources that need direct internet access.
resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = format("%s-dmz-%s", var.name, local.az_suffixes[count.index])
  }
}

# Private subnets are used for resources that do not require direct internet access.
# These subnets are isolated and typically communicate with the internet via NAT Gateways.
resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = format("%s-lan-%s", var.name, local.az_suffixes[count.index])
  }
}

############################
# Nat Gateway
############################
# Elastic IPs are allocated for NAT Gateways to provide internet access
# to private subnets. Ensure the number of EIPs matches the NAT Gateway count.
resource "aws_eip" "nat_ip" {
  count = local.nat_count

  domain = "vpc"

  tags = {
    Name = format("%s-eip-nat-%s", var.name, local.az_suffixes[count.index])
  }
}

# NAT Gateways allow private subnets to access the internet without exposing
# the resources directly. Ensure that each NAT Gateway is placed in a public subnet.
resource "aws_nat_gateway" "nat" {
  count = local.nat_count

  allocation_id = aws_eip.nat_ip[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = format("%s-nat-%s", var.name, local.az_suffixes[count.index])
  }
}

############################
# Route Tables
############################
# The public route table routes all traffic (0.0.0.0/0) to the Internet Gateway.
# This is required for public subnets to communicate with the internet.
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

# Private route tables route traffic from private subnets to the internet
# via NAT Gateways. If NAT Gateways are disabled, no routes are created.
resource "aws_route_table" "private" {
  count = local.private_route_table_count

  vpc_id = aws_vpc.main.id

  dynamic "route" {
    for_each = var.enable_nat_gateway ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat[var.single_nat_gateway ? 0 : count.index].id
    }
  }

  tags = {
    Name = format(
      "%s-private-routes-%s",
      var.name,
      var.enable_nat_gateway && var.single_nat_gateway ? "shared" : local.az_suffixes[count.index]
    )
  }
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[var.enable_nat_gateway && var.single_nat_gateway ? 0 : count.index].id
}
