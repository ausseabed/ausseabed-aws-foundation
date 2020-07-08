#-----networking/outputs.tf


output "app_tier_subnets" {
  value = data.aws_subnet_ids.app_tier_subnets.ids
}

output "vpc_id" {
  value = data.aws_vpc.ga_sb_vpc.id
}

output "vpc_arn" {
  value = data.aws_vpc.ga_sb_vpc.arn
}

output "aws_ecs_lb_target_group_geoserver_arn" {
  value = data.aws_lb_target_group.ga_sb_geoserver_load_balancer_outside.arn
}

output "ecs_geoserver_security_group_id" {
  value = data.aws_security_group.ga_sb_env_geoserver_public_sg.id
}
