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

locals {
  enable_ec2_test = false
  env = terraform.workspace
}
