output "aws_ecs_lb_target_group_geoserver_arn"{
  value = aws_lb_target_group.geoserver_outside.arn
}

output "ecs_task_execution_role_svc_arn" {
  value = aws_iam_role.ecs_task_execution_role_svc.arn
}

output "ecs_wh_security_group_id"{
  value = aws_security_group.warehouse_public_sg.id
}

output "wh_dns_zone" {
  value = local.wh_dns_zone
}
