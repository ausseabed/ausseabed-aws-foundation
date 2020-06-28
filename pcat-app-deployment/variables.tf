variable "aws_region" {}

variable "env" {
  type = string
  default = null
}

variable "server_cpu" {}
variable "server_memory" {}

variable "client_image" {
  type = string
  default = "288871573946.dkr.ecr.ap-southeast-2.amazonaws.com/ausseabed-product-catalogue-client:latest"
}
variable "server_image" {
  type = string
  default = "288871573946.dkr.ecr.ap-southeast-2.amazonaws.com/ausseabed-product-catalogue-server:latest"
}

variable "ga_sb_domain" {}
