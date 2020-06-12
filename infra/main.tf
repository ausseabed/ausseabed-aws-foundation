provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

locals {
  env        = (var.env != null) ? var.env : terraform.workspace
  account_id = data.aws_caller_identity.current.account_id
}


terraform {
  backend "s3" {
  }
}


module "networking" {
  source                 = "./networking"
  env                    = local.env
  ga_sb_vpc_cidr         = var.ga_sb_vpc_cidr
  ga_sb_web_subnet_cidrs = var.ga_sb_web_subnet_cidrs
  ga_sb_app_subnet_cidrs = var.ga_sb_app_subnet_cidrs
  ga_sb_db_subnet_cidrs  = var.ga_sb_db_subnet_cidrs

  ga_sb_web_subnet_segments = var.ga_sb_web_subnet_segments
  ga_sb_app_subnet_segments = var.ga_sb_app_subnet_segments
  ga_sb_db_subnet_segments  = var.ga_sb_db_subnet_segments

  ga_sb_vpc_az_count = var.az_count

  ga_sb_vpc_secondary_cidrs = var.ga_sb_vpc_secondary_cidrs
}

module "compute" {
  source     = "./compute"
  env        = local.env
  security   = module.security
  networking = module.networking
}

module "security" {
  source = "./security"
  env    = local.env
}

