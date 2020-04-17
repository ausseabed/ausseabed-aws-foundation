output "aws_ecs_geoserver_cluster_arn" {
  value = aws_ecs_cluster.ga_sb_wh_geoserver_cluster.arn
}


output "aws_ecs_task_definition_geoserver_arn" {
  value = aws_ecs_task_definition.geoserver.arn
}

