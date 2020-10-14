
locals {
  wh_dns_map = map(
          "default", "dev.ausseabed.gov.au",
          "prod", "ausseabed.gov.au"
  )
  wh_dns_zone = local.wh_dns_map[local.env]
}

data "aws_route53_zone" "ausseabed" {
  name         = "${local.wh_dns_zone}."
}

//data ""
//
//
resource "aws_route53_record" "spt_dns" {
  zone_id = data.aws_route53_zone.ausseabed.id
  name    = "spt.${local.wh_dns_zone}"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_ingress.example.load_balancer_ingress.0.hostname]
}
//
resource "aws_acm_certificate" "spt_cert" {
  domain_name       = "spt.${local.wh_dns_zone}"
  validation_method = "DNS"

  tags = {
    Environment = local.env
  }

  lifecycle {
    create_before_destroy = true
  }
}
//
resource "aws_route53_record" "example" {
  for_each = {
  for dvo in aws_acm_certificate.spt_cert.domain_validation_options : dvo.domain_name => {
    name   = dvo.resource_record_name
    record = dvo.resource_record_value
    type   = dvo.resource_record_type
  }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.ausseabed.zone_id
}

resource "aws_acm_certificate_validation" "example" {
  certificate_arn         = aws_acm_certificate.spt_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.example : record.fqdn]
}
