
variable "aws_region" {}

variable "env" {
  type    = string
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
variable "geoserver_image" {
  default = "288871573946.dkr.ecr.ap-southeast-2.amazonaws.com/ausseabed-geoserver:latest"
} # based on kartoza/geoserver

variable "server_cpu" {}
variable "server_memory" {}
variable "geoserver_initial_memory" {}
variable "geoserver_maximum_memory" {}
variable "geoserver_snapshot_iso_datetime" {
  type    = string
  default = null
}


