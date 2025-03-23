data "aws_route53_zone" "host_zone" {
  name = var.hosted_zone
}
