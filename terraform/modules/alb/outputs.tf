output "dns_name" {
  description = "DNS name of the load balancer."
  value       = aws_lb.main.dns_name
}

output "zone_id" {
  description = "Canonical hosted zone ID of the load balancer (to be used in a Route 53 alias reacord)."
  value       = aws_lb.main.zone_id
}

output "security_group_id" {
  description = "Load balancer security group ID"
  value       = aws_security_group.lb.id
}
