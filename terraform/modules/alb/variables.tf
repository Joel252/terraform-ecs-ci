variable "name" {
  description = <<EOF
  Name of the LB. This name must be unique within your AWS account, can have a maximum of 
  32 characters, must contain only alphanumeric characters or hyphens, and must not begin 
  or end with a hyphen. If not specified, Terraform will autogenerate a name beginning 
  with tf-lb.
  EOF
  type        = string
  default     = "tf-lb"
}

variable "vpc_id" {
  description = "Identifier of the VPC in which to create the target group."
  type        = string
}

variable "subnets" {
  description = <<EOF
  List of subnet IDs to attach to the LB. For Load Balancers of type network subnets can only 
  be added (see Availability Zones), deleting a subnet for load balancers of type network will 
  force a recreation of the resource.
  EOF
  type        = list(string)
  default     = []
}

variable "ssl_policy" {
  description = <<EOF
  Name of the SSL Policy for the listener. Required if protocol is HTTPS or TLS. 
  Default is ELBSecurityPolicy-2016-08.
  EOF
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}

variable "certificate_arn" {
  description = "ARN of the default SSL sever certificate."
  type        = string
  default     = ""
}

variable "target_port" {
  description = "Load balancer target group port."
  type        = number
  default     = 80
}

variable "target_protocol" {
  description = "Load balancer target group protocol."
  type        = string
  default     = "HTTP"
}

variable "health_check_interval" {
  description = <<EOF
  Approximate amount of time, in seconds, between health checks of an individual target. 
  The range is 5-300. Defaults to 30.
  EOF
  type        = number
  default     = 30
}

variable "health_check_path" {
  description = "Destination for the health check request. For HTTP and HTTPS health checks, the default is /"
  type        = string
  default     = "/"
}
