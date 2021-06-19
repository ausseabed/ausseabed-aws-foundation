resource "aws_s3_bucket" "mh370_cache" {
  bucket = "ausseabed-mh370-cache-${var.env}"
}
