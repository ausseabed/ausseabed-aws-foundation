locals {
  env    = (var.env != null) ? var.env : terraform.workspace
  secret = jsondecode(data.aws_secretsmanager_secret_version.wh-infra-secrets.secret_string)
  #TODO create .prod.aussueabed zone for internal communications
  product_catalogue_url = (var.env == "default") ? "https://catalogue.dev.ausseabed.gov.au/rest" : "https://catalogue.ausseabed.gov.au/rest"
}

provider "aws" {
  region = var.aws_region
}

//terraform {
//  backend "s3" {
//    bucket = "ausseabed-aws-foundation-tf-infra"
//    key    = "terraform/terraform-aws-foundation-wh-infra.tfstate"
//    region = "ap-southeast-2"
//
//  }
//}


data "aws_secretsmanager_secret" "wh-infra-secrets" {
  name = "wh-infra.auto.tfvars"
}

data "aws_secretsmanager_secret_version" "wh-infra-secrets" {
  secret_id = data.aws_secretsmanager_secret.wh-infra-secrets.id
}

module "networking" {
  source = "./networking"
  env    = local.env

}

module "ancillary" {
  source     = "./ancillary"
  env        = local.env
  aws_region = var.aws_region
  networking = module.networking
}

module "postgres" {
  source               = "./postgres"
  env                  = local.env
  aws_region           = var.aws_region
  postgres_server_spec = var.postgres_server_spec
  snapshot_identifier  = var.postgres_snapshot_id
  networking           = module.networking

}

