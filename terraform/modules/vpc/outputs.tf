output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs."
  value       = var.create_private_subnets ? aws_subnet.private[*].id : []
}
