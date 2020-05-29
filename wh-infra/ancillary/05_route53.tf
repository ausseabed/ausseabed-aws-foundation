data "aws_route53_zone" "ausseabed" {
  name         = "dev.ausseabed.gov.au."
}

resource "aws_route53_record" "warehouse_dns" {
  zone_id = data.aws_route53_zone.ausseabed.id
  name    = "warehouse.dev.ausseabed.gov.au."
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.geoserver_load_balancer.dns_name]
}

resource "aws_acm_certificate" "warehouse_cert" {
  domain_name       = "warehouse.dev.ausseabed.gov.au"
  validation_method = "DNS"

  tags = {
    Environment = "dev"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "warehouse_cert_validation" {
  name    = aws_acm_certificate.warehouse_cert.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.warehouse_cert.domain_validation_options.0.resource_record_type
  zone_id = data.aws_route53_zone.ausseabed.id
  records = [aws_acm_certificate.warehouse_cert.domain_validation_options.0.resource_record_value]
  ttl     = 60
}

