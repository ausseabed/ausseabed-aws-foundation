locals {
  env                   = (var.env != null) ? var.env : terraform.workspace
  secret                = jsondecode(data.aws_secretsmanager_secret_version.wh-infra-secrets.secret_string)
  #TODO create .prod.aussueabed zone for internal communications
  product_catalogue_url = (var.env == "default") ? "https://catalogue.dev.ausseabed.gov.au/rest" : "https://catalogue.ausseabed.gov.au/rest"
}

provider "aws" {
  region = var.aws_region
}

data "aws_secretsmanager_secret" "wh-infra-secrets" {
  name = "wh-infra.auto.tfvars"
}

data "aws_secretsmanager_secret_version" "wh-infra-secrets" {
  secret_id = data.aws_secretsmanager_secret.wh-infra-secrets.id
}

module "networking" {
  source       = "./networking"
  env          = local.env
}

module "geoserver" {
  source                                = "./geoserver"
  env                                   = local.env
  networking                            = module.networking
  geoserver_image                       = var.geoserver_image
  server_cpu                            = var.server_cpu
  server_memory                         = var.server_memory
  geoserver_environment_vars            = {
    geoserver_initial_memory = var.geoserver_initial_memory
    geoserver_maximum_memory = var.geoserver_maximum_memory
    geoserver_admin_password = var.geoserver_admin_password
    product_catalogue_url    = local.product_catalogue_url
    auth_host                = local.secret["auth_host"],
    auth_client_id           = local.secret["auth_client_id"],
    client_pem_thumbprint    = local.secret["client_pem_thumbprint"],
    client_pem_key           = local.secret["client_pem_key"]
    snapshot_iso_datetime    = (var.geoserver_snapshot_iso_datetime == null) ? timestamp(): var.geoserver_snapshot_iso_datetime
  }
}
