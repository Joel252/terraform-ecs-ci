variable "domain_name" {
  description = "Domain name registered in ACM"
  type        = string
}

variable "iam_instance_role" {
  description = "AWS IAM instance role"
  type        = string
}

variable "iam_task_execution_role" {
  description = "AWS IAM task execution role"
  type        = string
}

variable "image_name" {
  description = "Docker image name"
  type        = string

}
