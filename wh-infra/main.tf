locals {
  env = terraform.workspace
}

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "ausseabed-aws-foundation-tf-infra"
    key = "terraform/terraform-aws-foundation-wh-infra.tfstate"
    region = "ap-southeast-2"
  }
}


module "networking" {
  source = "./networking"
}

module "ancillary" {
  source = "./ancillary"
  env = local.env
  networking = module.networking
}

module "postgres" {
  source = "./postgres"
  env = local.env
  aws_region = var.aws_region
  postgres_admin_password = var.postgres_admin_password
  postgres_server_spec = var.postgres_server_spec
  networking = module.networking
}

module "geoserver" {
  source       = "./geoserver"
  env = local.env
  server_cpu                 = var.server_cpu
  server_memory              = var.server_memory
  ecs_task_execution_role_svc_arn = module.ancillary.ecs_task_execution_role_svc_arn
  networking = module.networking
  ecs_wh_security_group_id = module.ancillary.ecs_wh_security_group_id
  geoserver_image = var.geoserver_image
  geoserver_initial_memory = var.geoserver_initial_memory
  geoserver_maximum_memory = var.geoserver_maximum_memory
  geoserver_admin_password = var.geoserver_admin_password
  aws_ecs_lb_target_group_geoserver_arn = module.ancillary.aws_ecs_lb_target_group_geoserver_arn
}