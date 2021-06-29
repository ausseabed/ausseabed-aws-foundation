locals {
  mh370_storymap_subdomain = "mh370-storymap"
  mh370_storymap_domain    = "${local.mh370_storymap_subdomain}.${var.wh_dns_zone}"
}

data "aws_s3_bucket" "mh370_storymap_bucket" {
  bucket = var.mh370_storymap_bucket
}

resource "aws_cloudfront_origin_access_identity" "storymap_origin_access_identity" {
  comment = "MH370 StoryMap Cloudfront to S3 Access Identity - ${title(var.env)}"
}

resource "aws_cloudfront_distribution" "storymap_cloudfront_distribution" {
  origin {
    domain_name = data.aws_s3_bucket.mh370_storymap_bucket.bucket_domain_name
    origin_id   = "s3-${data.aws_s3_bucket.mh370_storymap_bucket.bucket}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.storymap_origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "MH370 StoryMap CloudFront Distribution (${var.env})"
  default_root_object = "index.html"

  aliases = [local.mh370_storymap_domain]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-${data.aws_s3_bucket.mh370_storymap_bucket.bucket}"

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.certificate.arn
    ssl_support_method  = "sni-only"
  }
}

resource "aws_route53_record" "storymap_dns_record" {
  zone_id = data.aws_route53_zone.zone.id
  name    = "${local.mh370_storymap_subdomain}."
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.storymap_cloudfront_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.storymap_cloudfront_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

data "aws_iam_policy_document" "storymap_s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${data.aws_s3_bucket.mh370_storymap_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.storymap_origin_access_identity.iam_arn]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = [data.aws_s3_bucket.mh370_storymap_bucket.arn]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.storymap_origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "storymap_bucket_policy" {
  bucket = data.aws_s3_bucket.mh370_storymap_bucket.id
  policy = data.aws_iam_policy_document.storymap_s3_policy.json
}
