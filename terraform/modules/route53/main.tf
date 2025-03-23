############################
# Route53 record
############################

resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.host_zone.zone_id
  name    = var.name
  type    = "A"

  alias {
    name                   = var.dns_name
    zone_id                = var.zone_id
    evaluate_target_health = var.evaluate_target_health
  }
}
