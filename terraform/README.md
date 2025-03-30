# Terraform Infraestructure

This Terraform configuration defines and provisions the core networking and routing infrastructure in AWS, allowing applications to be securely deployed and accessed.

<!-- BEGIN_TF_DOCS -->
## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | ./modules/alb | n/a |
| <a name="module_dns_record"></a> [dns\_record](#module\_dns\_record) | ./modules/route53 | n/a |
| <a name="module_ecs_tasks"></a> [ecs\_tasks](#module\_ecs\_tasks) | ./modules/ecs | n/a |
| <a name="module_network"></a> [network](#module\_network) | ./modules/vpc | n/a |
| <a name="module_template"></a> [template](#module\_template) | ./modules/ec2 | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | ARN of the SSL certificate for the ALB | `string` | n/a | yes |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | CIDR block for the VPC | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name registered in ACM | `string` | n/a | yes |
| <a name="input_ec2_config"></a> [ec2\_config](#input\_ec2\_config) | Instance configuration | <pre>object({<br/>    image                  = string<br/>    container_port         = number<br/>    instance_type          = string<br/>    volume_size            = number<br/>    volume_type            = string<br/>    ssh_security_group_ids = list(string)<br/>    num_instances          = number<br/>    task_role_name         = string<br/>  })</pre> | n/a | yes |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Whether to enable NAT Gateway | `bool` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | List of CIDR blocks for private subnets | `list(string)` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | List of CIDR blocks for public subnets | `list(string)` | n/a | yes |
| <a name="input_subdomain_name"></a> [subdomain\_name](#input\_subdomain\_name) | Subdomain name to create a record in Route53 | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
