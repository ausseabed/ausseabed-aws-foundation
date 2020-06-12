variable "env" {}

#------compute/variables.tf


variable "geoserver_environment_vars" {
  type = object({
    geoserver_initial_memory = string,
    geoserver_maximum_memory = string,
    geoserver_admin_password = string,
    auth_host                = string,
    auth_client_id           = string,
    client_pem_thumbprint    = string,
    client_pem_key           = string,
    product_catalogue_url    = string
  })
}

variable "server_cpu" {}
variable "server_memory" {}


variable "ecs_task_execution_role_svc_arn" {}

variable "geoserver_image" {}

variable "aws_ecs_lb_target_group_geoserver_arn" {}

variable "ecs_wh_security_group_id" {}


variable "networking" {
  type = object({
    vpc_id           = string,
    app_tier_subnets = list(string)
  })
}

