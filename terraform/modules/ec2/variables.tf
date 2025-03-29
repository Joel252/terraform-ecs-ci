variable "name" {
  description = "Base name for all resources."
  type        = string
  default     = "tf"
}

variable "instance_type" {
  description = "The type of the instance."
  type        = string
  default     = "t2.micro"
}

variable "volume_size" {
  description = "The size of the volume in gigabytes."
  type        = number
  default     = 8
}

variable "volume_type" {
  description = "The volume type. Can be one of standard, gp2, gp3, io1, io2, sc1 or st1."
  type        = string
  default     = "gp3"
}

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

variable "security_group_ids" {
  description = "List of Security Group IDs to allow access to the instance via SSH."
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "List of subnet IDs where the instances will be hosted."
  type        = list(string)
}

variable "num_instances" {
  description = "Number of Amazon EC2 instances that should be running in the group."
  type        = number
  default     = 2
}

variable "min_instances" {
  description = " Minimum size of the Auto Scaling Group."
  type        = number
  default     = 1
}

variable "max_instances" {
  description = "Maximum size of the Auto Scaling Group."
  type        = number
  default     = 2
}
