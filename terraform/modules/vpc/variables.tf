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

variable "num_az_to_use" {
  description = "Number of desired availability zones."
  type        = number
  default     = 2

  validation {
    condition     = var.num_az_to_use > 0 && var.num_az_to_use <= length(data.aws_availability_zones.available.names)
    error_message = "az_count must be greater than 0 and less than or equal to the number of available AZs."
  }
}

variable "create_private_subnets" {
  description = "Flag to indicate whether private subnets should be created."
  type        = bool
  default     = false
}

variable "enable_nat_gateway" {
  description = "Flag to indicate whether nat gateways should be created."
  type        = bool
  default     = false
}
