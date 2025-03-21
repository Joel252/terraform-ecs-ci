variable "hosted_zone" {
  description = "This is the name of the hosted zone."
  type        = string
}

variable "name" {
  description = "The name of the record."
  type        = string
}

variable "dns_name" {
  description = <<EOF
  DNS domain name for a CloudFront distribution, S3 bucket, ELB, AWS Global Accelerator, 
  or another resource record set in this hosted zone.
  EOF
  type        = string
}

variable "zone_id" {
  description = <<EOF
  Hosted zone ID for a CloudFront distribution, S3 bucket, ELB, AWS Global Accelerator, 
  or Route 53 hosted zone.
  EOF
  type        = string
}

variable "evaluate_target_health" {
  description = <<EOF
  Set to true if you want Route 53 to determine whether to respond to DNS queries using 
  this resource record set by checking the health of the resource record set.
  EOF
  type        = bool
  default     = false
}
