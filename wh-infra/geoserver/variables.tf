#------compute/variables.tf

variable "server_cpu"{}
variable "server_memory"{}
variable "geoserver_initial_memory"{}
variable "geoserver_maximum_memory"{}
variable "geoserver_admin_password"{}

variable "ecs_task_execution_role_svc_arn"{}

variable "geoserver_image"{}

variable "aws_ecs_lb_target_group_geoserver_arn"{}


variable "networking" {
  type = object({
    vpc_id = string,
    app_tier_subnets = set(string)
  })
}

