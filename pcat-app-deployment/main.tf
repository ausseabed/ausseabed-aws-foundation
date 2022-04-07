terraform {
  required_version = "= 0.12.19"
}

locals {
  env    = (var.env != null) ? var.env : terraform.workspace
  secret = jsondecode(data.aws_secretsmanager_secret_version.wh-infra-secrets.secret_string)
}

provider "aws" {
  region  = var.aws_region
  version = "2.54"
}

data "aws_secretsmanager_secret" "wh-infra-secrets" {
  name = "wh-infra.auto.tfvars"
}

data "aws_secretsmanager_secret_version" "wh-infra-secrets" {
  secret_id = data.aws_secretsmanager_secret.wh-infra-secrets.id
}

data "aws_db_instance" "asbwarehouse" {
  db_instance_identifier = "ga-sb-${local.env}-wh-asbwarehouse-db"
}

module "networking" {
  ga_sb_domain = var.ga_sb_domain
  source       = "./networking"
  env          = local.env
}

module "service" {
  source        = "./service"
  server_cpu    = var.server_cpu
  server_memory = var.server_memory
  client_image  = var.client_image
  server_image  = var.server_image
  networking    = module.networking
  product_catalogue_environment_vars = {
    pc_auth_host      = local.secret["auth_host"],
    pc_client_id      = local.secret["auth_client_id"],
    postgres_port     = data.aws_db_instance.asbwarehouse.port,
    postgres_user     = data.aws_db_instance.asbwarehouse.master_username,
    postgres_database = "ga_sb_${local.env}_wh_asbwarehouse_db",
    postgres_hostname = data.aws_db_instance.asbwarehouse.address
  }
  env = local.env
}
