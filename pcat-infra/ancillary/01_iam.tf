data "aws_iam_role" "ecs_task_execution_role_svc" {
  name = "ga_sb_${var.env}_ecs_task_execution_role_svc"
}
