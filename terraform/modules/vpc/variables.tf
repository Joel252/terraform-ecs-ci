variable "cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "name" {
  description = "Base name for all resources."
  type        = string
  default     = "tf"
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets."
  type        = list(string)
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets."
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  description = "Flag to indicate whether nat gateways should be created."
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Flag to indicate whether a single NAT gateway should be created and shared."
  type        = bool
  default     = true
}
