<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.ecs_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_capacity_provider.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_capacity_provider) | resource |
| [aws_ecs_cluster.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |
| [aws_ecs_service.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_policy.ecs_logs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.ecs_exec_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecs_exec_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_security_group_id"></a> [alb\_security\_group\_id](#input\_alb\_security\_group\_id) | ALB security group ID. | `string` | `null` | no |
| <a name="input_alb_target_group_arn"></a> [alb\_target\_group\_arn](#input\_alb\_target\_group\_arn) | ARN of the ALB security group | `string` | n/a | yes |
| <a name="input_auto_scaling_group_arn"></a> [auto\_scaling\_group\_arn](#input\_auto\_scaling\_group\_arn) | ARN of the associated auto scaling group. | `string` | n/a | yes |
| <a name="input_awslogs_region"></a> [awslogs\_region](#input\_awslogs\_region) | Specify the AWS Region that the awslogs log driver is to send your Docker logs to. | `string` | n/a | yes |
| <a name="input_container_cpu"></a> [container\_cpu](#input\_container\_cpu) | The number of cpu units the Amazon ECS container agent reserves for the container. | `number` | `128` | no |
| <a name="input_container_memory"></a> [container\_memory](#input\_container\_memory) | The amount (in MiB) of memory to present to the container. If your container attempts to exceed the memory specified here, <br/>  the container is killed. The total amount of memory reserved for all containers within a task must be lower than the task memory value, <br/>  if one is specified. | `number` | `256` | no |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | The port number on the container that's bound to the user-specified or automatically assigned host port. | `number` | `8080` | no |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | Number of cpu units used by the task. | `number` | `256` | no |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | Number of instances of the task definition to place and keep running. | `number` | `2` | no |
| <a name="input_execution_role_name"></a> [execution\_role\_name](#input\_execution\_role\_name) | Name of the task execution role that the Amazon ECS container agent and the Docker daemon can assume. | `string` | `null` | no |
| <a name="input_image"></a> [image](#input\_image) | The image used to start a container. This string is passed directly to the Docker daemon. <br/>  By default, images in the Docker Hub registry are available. You can also specify other <br/>  repositories with either repository-url/image:tag or repository-url/image@digest. | `string` | n/a | yes |
| <a name="input_logs_retention"></a> [logs\_retention](#input\_logs\_retention) | Logs retentions in days  for CloudWatch. | `number` | `7` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | Amount (in MiB) of memory used by the task. | `number` | `512` | no |
| <a name="input_name"></a> [name](#input\_name) | Base name for all resources. | `string` | `"tf"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs where the instances will be hosted. | `list(string)` | n/a | yes |
| <a name="input_task_role_name"></a> [task\_role\_name](#input\_task\_role\_name) | Name of IAM role that allows your Amazon ECS container task to make calls to other AWS services. | `string` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->