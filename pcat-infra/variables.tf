variable "aws_region" {}

variable "env" {
  type = string
  default = null
}

variable "server_cpu" {}
variable "server_memory" {}

variable "client_image" {}
variable "server_image" {}

variable "ga_sb_domain" {}
