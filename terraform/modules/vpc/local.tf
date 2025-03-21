locals {
  # Calculate the suffix for each AZ (e.g., "a", "b", "c")
  az_suffixes = [
    for az in data.aws_availability_zones.available.names
    : substr(az, -1, 1)
  ]

  # Determines number of nats to use
  nat_count = (var.enable_nat_gateway
    ? (var.single_nat_gateway ? 1 : length(var.private_subnets))
    : 0
  )

  # Determines number of route tables for private subnets
  private_route_table_count = (local.nat_count == 0
    ? length(var.private_subnets)
    : local.nat_count
  )
}
