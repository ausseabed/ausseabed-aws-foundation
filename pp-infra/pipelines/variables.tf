
variable env {}


variable "networking" {
  type = object({
    vpc_id = string,
    app_tier_subnets = set(string)
  })
}


variable "ausseabed_sm_role" {}

variable "aws_ecs_cluster_arn" {}
variable "aws_ecs_task_definition_gdal_arn" {}
variable "aws_ecs_task_definition_mbsystem_arn" {}
variable "aws_ecs_task_definition_pdal_arn" {}

variable "aws_ecs_task_definition_caris_version_arn" {}
variable "aws_ecs_task_definition_startstopec2_arn" {}
variable "local_storage_folder" {}
