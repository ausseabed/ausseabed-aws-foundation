resource "aws_ecr_repository" "ga_sb_repository" {
  name = "ga_sb_${var.env}_repository"
  image_tag_mutability = "MUTABLE"
  tags = {
    Name = "ga_sb_${var.env}_repository"
  }
}

