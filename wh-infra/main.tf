locals {
  env = terraform.workspace
  secret = jsondecode(data.aws_secretsmanager_secret_version.wh-infra-secrets.secret_string)
}

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "ausseabed-aws-foundation-tf-infra"
    key    = "terraform/terraform-aws-foundation-wh-infra.tfstate"
    region = "ap-southeast-2"
  }
}


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
  networking = module.networking
}

module "postgres" {
  source                  = "./postgres"
  env                     = local.env
  aws_region              = var.aws_region
  postgres_admin_password = var.postgres_admin_password
  postgres_server_spec    = var.postgres_server_spec
  networking              = module.networking
}

module "geoserver" {
  source                                = "./geoserver"
  env                                   = local.env
  ecs_task_execution_role_svc_arn       = module.ancillary.ecs_task_execution_role_svc_arn
  networking                            = module.networking
  ecs_wh_security_group_id              = module.ancillary.ecs_wh_security_group_id
  geoserver_image                       = var.geoserver_image
  aws_ecs_lb_target_group_geoserver_arn = module.ancillary.aws_ecs_lb_target_group_geoserver_arn
  server_cpu                            = var.server_cpu
  server_memory                         = var.server_memory
  geoserver_environment_vars = {
    geoserver_initial_memory = var.geoserver_initial_memory
    geoserver_maximum_memory = var.geoserver_maximum_memory
    geoserver_admin_password = var.geoserver_admin_password
    auth_host                = local.secret["auth_host"],
    auth_client_id           = local.secret["auth_client_id"],
    client_pem_thumbprint    = local.secret["client_pem_thumbprint"],
    client_pem_key           = local.secret["client_pem_key"]
  }
}
