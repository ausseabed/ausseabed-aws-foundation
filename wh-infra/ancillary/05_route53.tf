
locals {
  wh_dns_map = map(
    "default", "dev.ausseabed.gov.au",
    "prod", "ausseabed.gov.au"
  )
  wh_dns_zone = local.wh_dns_map[var.env]
}

data "aws_route53_zone" "ausseabed" {
  name = local.wh_dns_zone
}


resource "aws_route53_record" "warehouse_dns" {
  zone_id = data.aws_route53_zone.ausseabed.id
  name    = "warehouse.${local.wh_dns_zone}"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.geoserver_load_balancer.dns_name]
}

resource "aws_acm_certificate" "warehouse_cert" {
  domain_name       = "warehouse.${local.wh_dns_zone}"
  validation_method = "DNS"

  tags = {
    Environment = var.env
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "warehouse_cert_validation" {
  name    = tolist(aws_acm_certificate.warehouse_cert.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.warehouse_cert.domain_validation_options)[0].resource_record_type
  zone_id = data.aws_route53_zone.ausseabed.id
  records = [tolist(aws_acm_certificate.warehouse_cert.domain_validation_options)[0].resource_record_value]
  ttl     = 60
}

