/*
 * Defines variable values for this Terraform configuration.  
 * 
 * In this template, a single `terraform.tfvars` file is used to provide default values,  
 * but in a real implementation, each workspace can have its own version in different Git branches.  
 * 
 * This file allows customizing deployments by specifying environment-specific values  
 * without modifying the main Terraform configuration.
 */

cidr_block             = "10.0.0.0/16"
public_subnets         = ["10.0.0.0/24", "10.0.1.0/24"]
private_subnets        = ["10.0.2.0/24", "10.0.3.0/24"]
enable_nat_gateway     = false
single_nat_gateway     = false
certificate_arn        = ""
container_port         = 5000
target_protocol        = "HTTP"
domain_name            = "website.com"
instance_type          = "t2.micro"
volume_size            = 8
volume_type            = "gp3"
ssh_security_group_ids = []
num_instances          = 2
min_instances          = 1
max_instances          = 2
task_role_name         = null
execution_role_name    = null
image                  = ""
desired_count          = 2
