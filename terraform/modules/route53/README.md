# Route 53 Module

This Terraform module creates a **DNS record** in **AWS Route 53**, enabling domain name resolution for an Application Load Balancer (ALB) or another AWS resource. It includes:

- **Hosted Zone Lookup:** Fetches the existing Route 53 hosted zone using the provided domain name.
- D**NS Record (A Record):**
  - Creates an **A record** that maps the domain name (`var.name`) to an **AWS resource** (e.g., an ALB) using an **alias**.
  - Uses alias targeting with `evaluate_target_health = true` for health-based routing.

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
| [aws_route53_record.record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_name"></a> [dns\_name](#input\_dns\_name) | DNS domain name for a CloudFront distribution, S3 bucket, ELB, AWS Global Accelerator, <br/>  or another resource record set in this hosted zone. | `string` | n/a | yes |
| <a name="input_evaluate_target_health"></a> [evaluate\_target\_health](#input\_evaluate\_target\_health) | Set to true if you want Route 53 to determine whether to respond to DNS queries using <br/>  this resource record set by checking the health of the resource record set. | `bool` | `false` | no |
| <a name="input_hosted_zone"></a> [hosted\_zone](#input\_hosted\_zone) | This is the name of the hosted zone. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the record. | `string` | n/a | yes |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | Hosted zone ID for a CloudFront distribution, S3 bucket, ELB, AWS Global Accelerator, <br/>  or Route 53 hosted zone. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Example

```hcl
module "record" {
  source                 = "./modules/route53"
  hosted_zone            = "example.com"
  name                   = "app"
  dns_name               = module.alb.dns_name
  zone_id                = module.alb.zone_id
  evaluate_target_health = false
}
```
