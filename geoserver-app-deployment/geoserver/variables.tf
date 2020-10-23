variable "env" {}

#------compute/variables.tf


variable "geoserver_environment_vars" {
  type = object({
    geoserver_initial_memory = string,
    geoserver_maximum_memory = string,
    product_catalogue_url    = string,
    snapshot_iso_datetime    = string
  })
}

variable "server_cpu" {}
variable "server_memory" {}


variable "geoserver_image" {}



variable "networking" {
  type = object({
    vpc_id                                = string,
    app_tier_subnets                      = list(string),
    aws_ecs_lb_target_group_geoserver_arn = string,
    ecs_geoserver_security_group_id       = string,
  })
}

