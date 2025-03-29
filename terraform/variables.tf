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

variable "single_nat_gateway" {
  description = "Whether to use a single NAT Gateway"
  type        = bool
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate for the ALB"
  type        = string
}

variable "container_port" {
  description = "Port for ECS container"
  type        = number
}

variable "target_protocol" {
  description = "Target protocol for the ALB"
  type        = string
}

variable "domain_name" {
  description = "Domain name registered in ACM"
  type        = string
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
}

variable "volume_size" {
  description = "Volume size for EC2 instances"
  type        = number
}

variable "volume_type" {
  description = "Volume type for EC2 instances"
  type        = string
}

variable "ssh_security_group_ids" {
  description = "List of Security Group IDs to allow access to the instance via SSH."
  type        = list(string)
}

variable "num_instances" {
  description = "Number of EC2 instances"
  type        = number
}

variable "min_instances" {
  description = "Minimum number of EC2 instances"
  type        = number
}

variable "max_instances" {
  description = "Maximum number of EC2 instances"
  type        = number
}

# ECS task role name
variable "task_role_name" {
  description = "IAM role name for ECS tasks"
  type        = string
  default     = null
}

# ECS execution role name
variable "execution_role_name" {
  description = "IAM role name for ECS task execution"
  type        = string
  default     = null
}

# Container image for ECS tasks
variable "image" {
  description = "Container image for ECS tasks"
  type        = string
}

variable "desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
}
