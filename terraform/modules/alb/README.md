# Aplication Load Balancer (ALB) Module

This Terraform module provisions an **Application Load Balancer (ALB)** to distribute incoming HTTP/HTTPS traffic to a target group within a specified **VPC**. It inlcudes:

- **Application Load Balancer (ALB):** Publicly accessible and configured to route traffic to backend targets.
- **Security Group:** Allows inbound traffic on ports **80 (HTTP)** and **443 (HTTPS)** from any IP, and allows all outbound traffic.
- **Listeners:**
  - **_HTTPS Listener_** (if a certificate is provided) routes secure traffic to the target group.
  - **_HTTP Listener_** redirects HTTP to HTTPS if SSL is enabled; otherwise, forwards traffic directly.
- Target Group: Defines the backend instances or services receiving the traffic, with health checks enabled on the root path (`/`).

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
| [aws_lb.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_security_group.security](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | ARN of the default SSL sever certificate. | `string` | `""` | no |
| <a name="input_health_check_interval"></a> [health\_check\_interval](#input\_health\_check\_interval) | Approximate amount of time, in seconds, between health checks of an individual target. <br/>  The range is 5-300. Defaults to 30. | `number` | `30` | no |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | Destination for the health check request. For HTTP and HTTPS health checks, the default is / | `string` | `"/"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the LB. This name must be unique within your AWS account, can have a maximum of <br/>  32 characters, must contain only alphanumeric characters or hyphens, and must not begin <br/>  or end with a hyphen. If not specified, Terraform will autogenerate a name beginning <br/>  with tf-lb. | `string` | `"tf-lb"` | no |
| <a name="input_ssl_policy"></a> [ssl\_policy](#input\_ssl\_policy) | Name of the SSL Policy for the listener. Required if protocol is HTTPS or TLS. <br/>  Default is ELBSecurityPolicy-2016-08. | `string` | `"ELBSecurityPolicy-2016-08"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnet IDs to attach to the LB. For Load Balancers of type network subnets can only <br/>  be added (see Availability Zones), deleting a subnet for load balancers of type network will <br/>  force a recreation of the resource. | `list(string)` | `[]` | no |
| <a name="input_target_port"></a> [target\_port](#input\_target\_port) | Load balancer target group port. | `number` | `80` | no |
| <a name="input_target_protocol"></a> [target\_protocol](#input\_target\_protocol) | Load balancer target group protocol. | `string` | `"HTTP"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Identifier of the VPC in which to create the target group. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | DNS name of the load balancer. |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | Canonical hosted zone ID of the load balancer (to be used in a Route 53 alias reacord). |
<!-- END_TF_DOCS -->

## Example

```hcl
module "alb" {
  source                = "./modules/alb"
  name                  = "my-alb"
  vpc_id                = module.network.vpc_id
  subnets               = module.network.public_subnet_ids
  ssl_policy            = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn       = "arn:aws:acm:region:account-id:certificate/certificate-id"
  target_port           = 443
  target_protocol       = "HTTPS"
  health_check_path     = "/"
  health_check_interval = 30
}
```
