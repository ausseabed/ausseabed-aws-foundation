locals {
  env = (var.env != null) ? var.env : terraform.workspace
  #TODO create .prod.aussueabed zone for internal communications
  product_catalogue_url = (var.env == "default") ? "https://catalogue.dev.ausseabed.gov.au/rest" : "https://catalogue.ausseabed.gov.au/rest"
}

provider "aws" {
  region = var.aws_region
}

module "networking" {
  source = "./networking"
  env    = local.env
}

module "geoserver" {
  source          = "./geoserver"
  env             = local.env
  networking      = module.networking
  geoserver_image = var.geoserver_image
  server_cpu      = var.server_cpu
  server_memory   = var.server_memory
  aws_region      = var.aws_region
  geoserver_environment_vars = {
    geoserver_initial_memory = var.geoserver_initial_memory
    geoserver_maximum_memory = var.geoserver_maximum_memory
    product_catalogue_url    = local.product_catalogue_url
    snapshot_iso_datetime    = (var.geoserver_snapshot_iso_datetime == null) ? timestamp() : var.geoserver_snapshot_iso_datetime
  }
}
