resource "aws_s3_bucket" "mh370_cache" {
  bucket = "ausseabed-mh370-cache-${var.env}"
}

resource "aws_s3_bucket" "mh370_storymap" {
  bucket = "ausseabed-mh370-storymap-${var.env}"
}
