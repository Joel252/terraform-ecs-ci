variable "name" {
  description = "Base name for all resources."
  type        = string
  default     = "tf"
}

variable "auto_scaling_group_arn" {
  description = "ARN of the associated auto scaling group."
  type        = string
}

variable "cpu" {
  description = "Number of cpu units used by the task."
  type        = number
  default     = 256
  validation {
    condition     = var.cpu > 0
    error_message = "CPU units must be greater than 0."
  }
}

variable "memory" {
  description = "Amount (in MiB) of memory used by the task."
  type        = number
  default     = 512
  validation {
    condition     = var.memory > 0
    error_message = "Amount of memory must be greater than 0."
  }
}

variable "task_role_name" {
  description = "Name of IAM role that allows your Amazon ECS container task to make calls to other AWS services."
  type        = string
  default     = null
}

variable "execution_role_name" {
  description = "Name of the task execution role that the Amazon ECS container agent and the Docker daemon can assume."
  type        = string
  default     = null
}

variable "image" {
  description = <<EOF
  The image used to start a container. This string is passed directly to the Docker daemon. 
  By default, images in the Docker Hub registry are available. You can also specify other 
  repositories with either repository-url/image:tag or repository-url/image@digest.
  EOF
  type        = string
}

variable "container_memory" {
  description = <<EOF
  The amount (in MiB) of memory to present to the container. If your container attempts to exceed the memory specified here, 
  the container is killed. The total amount of memory reserved for all containers within a task must be lower than the task memory value, 
  if one is specified.
  EOF
  type        = number
  default     = 256
  validation {
    condition     = var.container_memory > 0
    error_message = "Amount of memory must be greater than 0."
  }
}

variable "container_cpu" {
  description = "The number of cpu units the Amazon ECS container agent reserves for the container."
  type        = number
  default     = 128
  validation {
    condition     = var.container_cpu > 0
    error_message = "CPU units must be greater than 0."
  }
}

variable "container_port" {
  description = "The port number on the container that's bound to the user-specified or automatically assigned host port."
  type        = number
  default     = 8080
}

variable "awslogs_region" {
  description = "Specify the AWS Region that the awslogs log driver is to send your Docker logs to. "
  type        = string
}

variable "desired_count" {
  description = "Number of instances of the task definition to place and keep running."
  type        = number
  default     = 2
}

variable "subnet_ids" {
  description = "List of subnet IDs where the instances will be hosted."
  type        = list(string)
}

variable "alb_target_group_arn" {
  description = "ARN of the ALB security group"
  type        = string
}

variable "logs_retention" {
  description = "Logs retentions in days  for CloudWatch."
  type        = number
  default     = 7
}

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

variable "alb_security_group_id" {
  description = "ALB security group ID."
  type        = string
  default     = null
}
