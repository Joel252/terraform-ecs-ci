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
}

variable "memory" {
  description = "Amount (in MiB) of memory used by the task."
  type        = number
  default     = 512
}

variable "task_role_arn" {
  description = "ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services."
  type        = string
  default     = null
}

variable "execution_role_arn" {
  description = "ARN of the task execution role that the Amazon ECS container agent and the Docker daemon can assume."
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
}

variable "container_cpu" {
  description = "The number of cpu units the Amazon ECS container agent reserves for the container."
  type        = number
  default     = 128
}

variable "container_port" {
  description = "The port number on the container that's bound to the user-specified or automatically assigned host port."
  type        = number
  default     = 80
}

variable "host_port" {
  description = "The port number on the container instance to reserve for your container."
  type        = number
  default     = 8080
}

variable "awslogs_region" {
  description = "Specify the AWS Region that the awslogs log driver is to send your Docker logs to. "
  type        = string
}

variable "num_instances" {
  description = "Number of Amazon EC2 instances of container images that should be running on ECS cluster."
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
