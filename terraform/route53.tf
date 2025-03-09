# Create Route 53 Hosted Zone for the domain of our service including A records in the top level domain

data "aws_route53_zone" "host_zone" {
  name = var.domain_name
}

resource "aws_acm_certificate" "certificate" {
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"

  # It's recommended to specify 'create_before_destroy = true' in a lifecycle block 
  # to replace a certificate which is currently in use
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "certificate_validation" {
  for_each = toset(aws_acm_certificate.certificate.validation_record_fqdns)

  zone_id = data.aws_route53_zone.host_zone.zone_id
  name    = each.value
  type    = "CNAME"
  ttl     = 60
  records = [aws_acm_certificate.certificate.validation_record_values[each.key]]
}

resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.host_zone.zone_id
  name    = "example"
  type    = "A"

  alias {
    name                   = aws_lb.ecs-alb.dns_name
    zone_id                = aws_lb.ecs-alb.zone_id
    evaluate_target_health = true
  }
}
