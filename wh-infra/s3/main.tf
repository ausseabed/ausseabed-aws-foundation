resource "aws_s3_bucket" "mh370_cache" {
  bucket = "ausseabed-mh370-cache-${var.env}"
}

resource "aws_s3_bucket" "mh370_storymap" {
  bucket = "ausseabed-mh370-storymap-${var.env}"
}

# Bucket for files required to build environments. Build processes can pull from here.
resource "aws_s3_bucket" "staging" {
  bucket = "ausseabed-staging-${var.env}"

  cors_rule {
    allowed_headers = [
      "*"
    ]
    allowed_methods = [
      "GET"
    ]
    allowed_origins = [
      "*"
    ]
    expose_headers  = []
    max_age_seconds = 3600
  }
}

resource "aws_s3_bucket_public_access_block" "staging_bucket_public_access_block" {
  bucket = aws_s3_bucket.staging.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
