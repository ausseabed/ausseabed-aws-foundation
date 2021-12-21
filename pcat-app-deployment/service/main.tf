data "aws_ecs_cluster" "ga_sb_default_geoserver_cluster" {
  cluster_name = "ga_sb_${var.env}_geoserver_cluster"
}

data "aws_iam_role" "ecs_task_execution_role_svc" {
  name = "ga_sb_${var.env}_ecs_task_execution_role_svc"
}


data "aws_secretsmanager_secret" "postgres_password" {
  name = "TF_VAR_postgres_admin_password"
}

data "aws_secretsmanager_secret_version" "postgres_password" {
  secret_id = data.aws_secretsmanager_secret.postgres_password.id
}



resource "aws_ecs_service" "ga_sb_pc_service" {
  name                              = "ga_sb_${var.env}_pc_service"
  cluster                           = data.aws_ecs_cluster.ga_sb_default_geoserver_cluster.id
  task_definition                   = aws_ecs_task_definition.ga_sb_pc_serverclient.arn
  desired_count                     = 1
  launch_type                       = "FARGATE"
  health_check_grace_period_seconds = 300

  load_balancer {
    target_group_arn = var.networking.aws_ecs_lb_target_group_product_catalogue_arn
    container_name   = "ga_sb_${var.env}_product_catalogue_client_task"
    container_port   = 3001
  }

//  load_balancer {
//    target_group_arn = var.networking.aws_ecs_lb_target_group_mh370api_arn
//    container_name   = "ga_sb_${var.env}_product_catalogue_client_task"
//    container_port   = 3002
//  }

  network_configuration {
    subnets = [
      var.networking.app_tier_subnets[0]
    ]
    security_groups = [
      var.networking.ecs_pc_security_group_id
    ]
    assign_public_ip = false
  }
}
locals {
  apc_version = (regex(".*:([^:]*)", var.client_image)[0] == "latest" ? formatdate("YYYY-MM-DD'T'hh:mm:ssZZZZ", timestamp()) : regex(".*:([^:]*)", var.client_image)[0])
}
# TODO need to specify this for product catalogue
resource "aws_ecs_task_definition" "ga_sb_pc_serverclient" {
  family             = "ga_sb_${var.env}_pc_serverclient"
  cpu                = var.server_cpu
  memory             = var.server_memory
  network_mode       = "awsvpc"
  execution_role_arn = data.aws_iam_role.ecs_task_execution_role_svc.arn
  task_role_arn      = data.aws_iam_role.ecs_task_execution_role_svc.arn
  requires_compatibilities = [
  "FARGATE"]
  container_definitions = <<DEFINITION
[
  {
    "logConfiguration": {
      "logDriver": "awslogs",
      "secretOptions": null,
      "options": {
        "awslogs-group": "/ecs/ga_sb_${var.env}_product_catalogue",
        "awslogs-region": "ap-southeast-2",
        "awslogs-stream-prefix": "server"
      }
    },
    "image": "${var.server_image}",
    "name": "ga_sb_${var.env}_product_catalogue_server_task",
    "networkMode": "awsvpc",
    "secrets": [
      {
        "name": "POSTGRES_PASSWORD",
        "valueFrom": "${data.aws_secretsmanager_secret_version.postgres_password.secret_id}"
      }],
    "environment": [
      {
        "name": "AUTH_HOST",
        "value": "${var.product_catalogue_environment_vars.pc_auth_host}"
      },
      {
        "name": "AUTH_CLIENT_ID",
        "value": "${var.product_catalogue_environment_vars.pc_client_id}"
      },
      {
        "name": "POSTGRES_PORT",
        "value": "${var.product_catalogue_environment_vars.postgres_port}"
      },
      {
        "name": "POSTGRES_USER",
        "value": "${var.product_catalogue_environment_vars.postgres_user}"
      },
      {
        "name": "POSTGRES_DATABASE",
        "value": "${var.product_catalogue_environment_vars.postgres_database}"
      },
      {
        "name": "POSTGRES_HOSTNAME",
        "value": "${var.product_catalogue_environment_vars.postgres_hostname}"
      }
    ],
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000,
        "protocol": "tcp"
      },
      {
        "containerPort": 3002,
        "hostPort": 3002,
        "protocol": "tcp"
      }
    ],
    "volumesFrom": []
  },
  {
    "logConfiguration": {
      "logDriver": "awslogs",
      "secretOptions": null,
      "options": {
        "awslogs-group": "/ecs/ga_sb_${var.env}_product_catalogue",
        "awslogs-region": "ap-southeast-2",
        "awslogs-stream-prefix": "client"
      }
    },
    "image": "${var.client_image}",
    "name": "ga_sb_${var.env}_product_catalogue_client_task",
    "networkMode": "awsvpc",
    "environment": [
      {
        "name": "APC_VERSION",
        "value": "${local.apc_version}"
      },
      {
        "name": "AUTH_HOST",
        "value": "${var.product_catalogue_environment_vars.pc_auth_host}"
      },
      {
        "name": "AUTH_CLIENT_ID",
        "value": "${var.product_catalogue_environment_vars.pc_client_id}"
      }
    ],
    "portMappings": [
      {
        "containerPort": 3001,
        "hostPort": 3001,
        "protocol": "tcp"
      }
    ]
  }
]
DEFINITION
}
