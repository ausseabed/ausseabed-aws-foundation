locals {
  env = (var.env != null) ? var.env : "default"
}

provider "aws" {
  region  = var.aws_region
}
