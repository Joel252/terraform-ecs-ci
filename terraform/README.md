# Terraform Infraestructure

This Terraform configuration defines and provisions the core networking and routing infrastructure in AWS, allowing applications to be securely deployed and accessed.

The user defines:

- A VPC with both public and private subnets, enabling internal and external communication.
- An Application Load Balancer (ALB) to distribute traffic over HTTP/HTTPS, improving availability and scalability.
- A Route 53 DNS alias to map a subdomain to the ALB, ensuring seamless domain resolution.

These configurations enable a scalable, secure, and highly available cloud environment.

<!-- BEGIN_TF_DOCS -->
## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | ./modules/alb | n/a |
| <a name="module_network"></a> [network](#module\_network) | ./modules/vpc | n/a |
| <a name="module_record"></a> [record](#module\_record) | ./modules/route53 | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->
