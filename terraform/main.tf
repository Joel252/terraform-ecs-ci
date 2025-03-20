/*
 * This Terraform configuration defines and provisions the core networking and routing infrastructure in AWS, 
 * allowing applications to be securely deployed and accessed. 
 * 
 * The user defines:
 * - A VPC with both public and private subnets, enabling internal and external communication.
 * - An Application Load Balancer (ALB) to distribute traffic over HTTP/HTTPS, improving availability and scalability.
 * - A Route 53 DNS alias to map a subdomain to the ALB, ensuring seamless domain resolution.
 * 
 * These configurations enable a scalable, secure, and highly available cloud environment.
 */

module "network" {
  source = "./modules/vpc"

  name                   = local.name
  cidr_block             = "10.0.0.0/16"
  num_az_to_use          = 2
  create_private_subnets = true
  enable_nat_gateway     = true
}

module "alb" {
  source = "./modules/alb"

  name            = local.name
  vpc_id          = module.network.vpc_id
  subnets         = module.vpc.public_subnet_ids
  ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn = ""
  target_port     = 80
  target_protocol = "HTTP"
}

module "alias" {
  source = "./modules/route53"

  hosted_zone = "website.com"
  name        = "www"
  dns_name    = module.alb.dns_name
  zone_id     = module.alb.zone_id
}
