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

module "service" {
  source                             = "./service"
  server_cpu                         = var.server_cpu
  server_memory                      = var.server_memory
  ecs_task_execution_role_svc_arn    = module.ancillary.pc_ecs_task_execution_role_svc_arn
  client_image                       = var.client_image
  server_image                       = var.server_image
  networking                         = module.networking
  product_catalogue_environment_vars = {
    pc_auth_host      = local.secret["auth_host"],
    pc_client_id      = local.secret["auth_client_id"],
    postgres_password = local.postgres_password["TF_VAR_postgres_admin_password"]
#    postgres_password = "{55250dfe-63b9-4f0a-8ac6-5cd47dd2de36}b",
    postgres_port     = data.aws_db_instance.asbwarehouse.port,
    postgres_user     = data.aws_db_instance.asbwarehouse.master_username,
    postgres_database = data.aws_db_instance.asbwarehouse.db_name,
    postgres_hostname = data.aws_db_instance.asbwarehouse.address

  }
  env                                = local.env
}

