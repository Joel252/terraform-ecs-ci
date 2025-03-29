/*
 * Main Terraform configuration file for deploying an ECS-based application.
 *
 * This file orchestrates the deployment of multiple modules to create the necessary
 * infrastructure for running a containerized application on AWS.
 **/

module "network" {
  source = "./modules/vpc"

  name               = local.project_name
  cidr_block         = var.cidr_block
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
}

module "alb" {
  source = "./modules/alb"

  name                  = local.project_name
  vpc_id                = module.network.vpc_id
  subnets               = module.network.public_subnet_ids
  ssl_policy            = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn       = var.certificate_arn
  target_port           = var.container_port
  target_protocol       = var.target_protocol
  health_check_path     = "/"
  health_check_interval = 30
}

module "dns_record" {
  source = "./modules/route53"

  hosted_zone            = var.domain_name
  name                   = "www"
  dns_name               = module.alb.dns_name
  zone_id                = module.alb.zone_id
  evaluate_target_health = false
}

module "template" {
  source = "./modules/ec2"

  name               = local.project_name
  instance_type      = var.instance_type
  volume_size        = var.volume_size
  volume_type        = var.volume_type
  vpc_id             = module.network.vpc_id
  security_group_ids = var.ssh_security_group_ids
  subnet_ids         = module.network.public_subnet_ids
  num_instances      = var.num_instances
  min_instances      = var.min_instances
  max_instances      = var.max_instances
}

module "ecs_tasks" {
  source = "./modules/ecs"

  name                   = local.project_name
  auto_scaling_group_arn = module.template.auto_scaling_group_arn
  cpu                    = 256
  memory                 = 512
  task_role_name         = var.task_role_name
  execution_role_name    = var.execution_role_name
  image                  = var.image
  container_cpu          = 128
  container_memory       = 256
  container_port         = var.container_port
  awslogs_region         = local.region
  desired_count          = var.desired_count
  subnet_ids             = module.network.public_subnet_ids
  alb_target_group_arn   = module.alb.target_group_arn
  logs_retention         = 1
  vpc_id                 = module.network.vpc_id
  alb_security_group_id  = module.alb.security_group_id
}
