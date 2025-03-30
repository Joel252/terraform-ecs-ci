variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Whether to enable NAT Gateway"
  type        = bool
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate for the ALB"
  type        = string
}

variable "domain_name" {
  description = "Domain name registered in ACM"
  type        = string
}

variable "subdomain_name" {
  description = "Subdomain name to create a record in Route53"
  type        = string
}

variable "ec2_config" {
  description = "Instance configuration"
  type = object({
    image                  = string
    container_port         = number
    instance_type          = string
    volume_size            = number
    volume_type            = string
    ssh_security_group_ids = list(string)
    num_instances          = number
    task_role_name         = string
  })
}
