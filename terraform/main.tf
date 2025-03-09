terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  // Change protocol "http" to "local" to run in local
  backend "http" {
  }
}

provider "aws" {
}
