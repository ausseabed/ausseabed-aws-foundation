provider "aws" {
  region = "us-east-1"
  alias  = "acm-region"
}

data "aws_acm_certificate" "certificate" {
  provider    = aws.acm-region
  domain      = var.wh_dns_zone
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

data "aws_route53_zone" "zone" {
  name = "${var.wh_dns_zone}."
}
