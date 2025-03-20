/*
 * Configures the AWS provider for Terraform, ensuring all resources are deployed in the specified
 * region with consistent settings.  
 * 
 * This setup:
 * - Defines the AWS region for resource deployment.  
 * - Applies default tags to all resources for better organization.  
 * - Specifies the required AWS provider version for compatibility.  
 * 
 * These settings help standardize and streamline infrastructure deployment using this project template.  
 */

provider "aws" {
  region = local.region

  # These tags will be used in all deployed resources
  default_tags {
    tags = local.tags
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Use any version from 5.x
    }
  }
}
