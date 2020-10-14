locals {
  env = (var.env != null) ? var.env : "default"
}

provider "aws" {
  region  = var.aws_region
  version = "2.54"
}

module "networking" {
  source = "./networking"
  env    = local.env

}

module "cluster" {
  source = "./cluster"
  env        = local.env
  networking = module.networking
}

