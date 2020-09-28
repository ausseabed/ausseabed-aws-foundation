

data "aws_ecs_cluster" "ga_sb_default_geoserver_cluster" {
  cluster_name = "ga_sb_${var.env}_geoserver_cluster"
}

data "aws_iam_role" "ecs_task_execution_role_svc" {
  name = "ga_sb_${var.env}_ecs_task_execution_role_svc"
}

resource "aws_ecs_task_definition" "geoserver" {
  family                   = "ga_sb_${var.env}_wh_geoserver"
  cpu                      = var.server_cpu
  memory                   = var.server_memory
  network_mode             = "awsvpc"
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role_svc.arn
  task_role_arn            = data.aws_iam_role.ecs_task_execution_role_svc.arn
  requires_compatibilities = ["FARGATE"]
  container_definitions    = <<DEFINITION
[
  {
    "logConfiguration": {
      "logDriver": "awslogs",
      "secretOptions": null,
      "options": {
        "awslogs-group": "/ecs/ga_sb_${var.env}_geoserver",
        "awslogs-region": "ap-southeast-2",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "image": "${var.geoserver_image}",
    "name": "geoserver-task",
    "networkMode": "awsvpc",
    "environment": [
      {
        "name": "GEOSERVER_URL",
        "value": "http://localhost:8080/geoserver"
      },
      {
        "name": "LIST_PATH",
        "value": "${var.geoserver_environment_vars.product_catalogue_url}"
      },
      {
        "name": "INITIAL_MEMORY",
        "value": "${var.geoserver_environment_vars.geoserver_initial_memory}"
      },
      {
        "name": "MAXIMUM_MEMORY",
        "value": "${var.geoserver_environment_vars.geoserver_maximum_memory}"
      },
      {
        "name": "GEOSERVER_ADMIN_PASSWORD",
        "value" : "${var.geoserver_environment_vars.geoserver_admin_password}" 
      },
      {
        "name": "COMMUNITY_EXTENSIONS",
        "value" : "s3-geotiff-plugin" 
      },
      {
        "name": "AUTH_HOST",
        "value" : "${var.geoserver_environment_vars.auth_host}" 
      },
      {
        "name": "AUTH_CLIENT_ID",
        "value" : "${var.geoserver_environment_vars.auth_client_id}" 
      },
      {
        "name": "CLIENT_PEM_THUMBPRINT",
        "value" : "${var.geoserver_environment_vars.client_pem_thumbprint}" 
      },
      {
        "name": "CLIENT_PEM_KEY",
        "value" : "${var.geoserver_environment_vars.client_pem_key}" 
      },
      {
        "name": "SNAPSHOT_ISO_DATETIME",
        "value" : "${var.geoserver_environment_vars.snapshot_iso_datetime}" 
      }
    ],
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8080,
        "protocol": "tcp"
      }
    ]
  }
]
DEFINITION
}


resource "aws_ecs_service" "geoserver_service" {
  name            = "ga_sb_${var.env}_geoserver_service"
  cluster         = data.aws_ecs_cluster.ga_sb_default_geoserver_cluster.id
  task_definition = aws_ecs_task_definition.geoserver.arn
  desired_count   = var.env == "prod" ? 3 : 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = var.networking.aws_ecs_lb_target_group_geoserver_arn
    container_name   = "geoserver-task"
    container_port   = 8080
  }

  network_configuration {
    subnets = [
    var.networking.app_tier_subnets[0]]
    security_groups = [
    var.networking.ecs_geoserver_security_group_id]
    assign_public_ip = false
  }

}
