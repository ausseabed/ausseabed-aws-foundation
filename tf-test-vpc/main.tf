provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "ausseabed-aws-foundation-tf-infra"
    key    = "terraform/terraform-aws-foundation-tests.tfstate"
    region = "ap-southeast-2"
  }
}




