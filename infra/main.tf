locals {
  env = terraform.workspace
}

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "ausseabed-aws-foundation-tf-infra"
    key    = "terraform/terraform-aws-foundation.tfstate"
    region = "ap-southeast-2"
  }
}


module "networking" {
  source       = "./networking"
  ga_sb_vpc_cidr     = var.ga_sb_vpc_cidr
  ga_sb_web_subnet_cidrs = var.ga_sb_web_subnet_cidrs
  ga_sb_app_subnet_cidrs = var.ga_sb_app_subnet_cidrs
  ga_sb_db_subnet_cidrs = var.ga_sb_db_subnet_cidrs

  ga_sb_web_subnet_segments = var.ga_sb_web_subnet_segments
  ga_sb_app_subnet_segments = var.ga_sb_app_subnet_segments
  ga_sb_db_subnet_segments = var.ga_sb_db_subnet_segments

  ga_sb_vpc_az_count = var.az_count

  ga_sb_vpc_secondary_cidrs = var.ga_sb_vpc_secondary_cidrs
}

module "compute" {
  source = "./compute"
  env = local.env
}

