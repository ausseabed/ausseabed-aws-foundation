output "mh370_cache_bucket" {
  value = aws_s3_bucket.mh370_cache.id
}

output "mh370_storymap_bucket" {
  value = aws_s3_bucket.mh370_storymap.id
}
