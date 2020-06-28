locals {
  env    = (var.env != null) ? var.env : terraform.workspace
  secret = jsondecode(data.aws_secretsmanager_secret_version.wh-infra-secrets.secret_string)
  postgres_password = jsondecode(data.aws_secretsmanager_secret_version.postgres_password.secret_string)

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

data "aws_secretsmanager_secret" "postgres_password" {
  name = "TF_VAR_postgres_admin_password"
}

data "aws_secretsmanager_secret_version" "postgres_password" {
  secret_id = data.aws_secretsmanager_secret.postgres_password.id
}



data "aws_db_instance" "asbwarehouse" {
  db_instance_identifier = "ga-sb-${local.env}-wh-asbwarehouse-db"
}

module "networking" {
  ga_sb_domain = var.ga_sb_domain
  source       = "./networking"
  env          = local.env
}

module "ancillary" {
  source = "./ancillary"
  env    = local.env
}
