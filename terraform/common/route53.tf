data "aws_route53_zone" "domain" {
  name = var.domain
}

resource "aws_route53_record" "common" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "*.${var.domain}"
  type    = "A"

  alias {
    name                   = aws_lb.ecs_deploy.dns_name
    zone_id                = aws_lb.ecs_deploy.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id         = data.aws_route53_zone.domain.zone_id
  ttl             = 60
  allow_overwrite = true
  name            = each.value.name
  records = [
    each.value.record,
  ]
  type = each.value.type
}