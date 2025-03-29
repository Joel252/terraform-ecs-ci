# Terraform Infraestructure

This Terraform configuration defines and provisions the core networking and routing infrastructure in AWS, allowing applications to be securely deployed and accessed.

The user defines:

- A VPC with both public and private subnets, enabling internal and external communication.
- An Application Load Balancer (ALB) to distribute traffic over HTTP/HTTPS, improving availability and scalability.
- A Route 53 DNS alias to map a subdomain to the ALB, ensuring seamless domain resolution.
- Configure an Auto Scaling Group for EC2 instances.
- Configure ECS tasks to run Docker containers.

These configurations enable a scalable, secure, and highly available cloud environment.

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
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | Port for ECS container | `number` | n/a | yes |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | Desired number of ECS tasks | `number` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name registered in ACM | `string` | n/a | yes |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Whether to enable NAT Gateway | `bool` | n/a | yes |
| <a name="input_execution_role_name"></a> [execution\_role\_name](#input\_execution\_role\_name) | IAM role name for ECS task execution | `string` | `null` | no |
| <a name="input_image"></a> [image](#input\_image) | Container image for ECS tasks | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type for EC2 instances | `string` | n/a | yes |
| <a name="input_max_instances"></a> [max\_instances](#input\_max\_instances) | Maximum number of EC2 instances | `number` | n/a | yes |
| <a name="input_min_instances"></a> [min\_instances](#input\_min\_instances) | Minimum number of EC2 instances | `number` | n/a | yes |
| <a name="input_num_instances"></a> [num\_instances](#input\_num\_instances) | Number of EC2 instances | `number` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | List of CIDR blocks for private subnets | `list(string)` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | List of CIDR blocks for public subnets | `list(string)` | n/a | yes |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | Whether to use a single NAT Gateway | `bool` | n/a | yes |
| <a name="input_ssh_security_group_ids"></a> [ssh\_security\_group\_ids](#input\_ssh\_security\_group\_ids) | List of Security Group IDs to allow access to the instance via SSH. | `list(string)` | n/a | yes |
| <a name="input_target_protocol"></a> [target\_protocol](#input\_target\_protocol) | Target protocol for the ALB | `string` | n/a | yes |
| <a name="input_task_role_name"></a> [task\_role\_name](#input\_task\_role\_name) | IAM role name for ECS tasks | `string` | `null` | no |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | Volume size for EC2 instances | `number` | n/a | yes |
| <a name="input_volume_type"></a> [volume\_type](#input\_volume\_type) | Volume type for EC2 instances | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
