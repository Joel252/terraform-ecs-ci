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
| [aws_autoscaling_group.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_iam_instance_profile.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_template.ecs_ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_security_group.ecs_ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The type of the instance. | `string` | `"t2.micro"` | no |
| <a name="input_max_instances"></a> [max\_instances](#input\_max\_instances) | Maximum size of the Auto Scaling Group. | `number` | `2` | no |
| <a name="input_min_instances"></a> [min\_instances](#input\_min\_instances) | Minimum size of the Auto Scaling Group. | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | Base name for all resources. | `string` | `"tf"` | no |
| <a name="input_num_instances"></a> [num\_instances](#input\_num\_instances) | Number of Amazon EC2 instances that should be running in the group. | `number` | `2` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of Security Group IDs to allow access to the instance via SSH. | `list(string)` | `[]` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs where the instances will be hosted. | `list(string)` | n/a | yes |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | The size of the volume in gigabytes. | `number` | `8` | no |
| <a name="input_volume_type"></a> [volume\_type](#input\_volume\_type) | The volume type. Can be one of standard, gp2, gp3, io1, io2, sc1 or st1. | `string` | `"gp3"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_auto_scaling_group_arn"></a> [auto\_scaling\_group\_arn](#output\_auto\_scaling\_group\_arn) | ARN of the scaling group. |
<!-- END_TF_DOCS -->