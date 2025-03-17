/*
 * Configure the provider that Terraform will use to interact with the API's and cloud
 * services providers.
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
