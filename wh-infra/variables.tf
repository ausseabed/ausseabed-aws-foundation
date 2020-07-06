
variable "aws_region" {}

variable "env" {
  type = string
  default = null
}

#------ storage variables



#-------networking variables

variable "vpc_cidr" {}

variable "public_cidrs" {
  type = list(string)
}

variable "accessip" {}

#-------compute variables

#variable "fargate_cpu"{}
#variable "fargate_memory"{}
variable "geoserver_image" {} # based on kartoza/geoserver

variable "server_cpu" {}
variable "server_memory" {}
variable "geoserver_initial_memory" {}
variable "geoserver_maximum_memory" {}
variable "geoserver_admin_password" {}
variable "geoserver_snapshot_iso_datetime"{
  type = string
  default = null
}

variable "postgres_admin_password" {}
variable "postgres_server_spec" {}
variable "postgres_snapshot_id" {
  type = string
  default = null
}