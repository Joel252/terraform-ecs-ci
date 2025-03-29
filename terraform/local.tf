locals {
  region      = "us-east-1"
  namespace   = "tf"
  environment = "test"
  project     = "web"

  project_name = format("%s-%s-%s", local.namespace, local.environment, local.project)

  tags = {
    ManageBy    = "Terraform"
    Team        = "Devops"
    Project     = title(local.project)
    Environment = title(local.environment)
  }
}
