output "auto_scaling_group_arn" {
  description = "ARN of the scaling group."
  value       = aws_autoscaling_group.ecs.arn
}
