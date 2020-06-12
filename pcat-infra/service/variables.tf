#------compute/variables.tf
variable "env" {}
variable "server_cpu" {}
variable "server_memory" {}
variable "ecs_task_execution_role_svc_arn" {}

variable "client_image" {}
variable "server_image" {}

variable "networking" {
  type = object({
    vpc_id                                        = string,
    app_tier_subnets                              = list(string),
    aws_ecs_lb_target_group_product_catalogue_arn = string,
    ecs_pc_security_group_id                      = string
  })
}

variable "product_catalogue_environment_vars" {
  type = object({
    pc_auth_host      = string,
    pc_client_id      = string,
    postgres_password = string,
    postgres_port     = number,
    postgres_user     = string,
    postgres_database = string,
    postgres_hostname = string
  })
}
