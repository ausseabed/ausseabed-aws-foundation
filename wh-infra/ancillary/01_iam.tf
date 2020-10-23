
data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}


resource "aws_iam_role" "ecs_task_execution_role_svc" {
  name = "ga_sb_${var.env}_ecs_task_execution_role_svc"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_role_policy" "ecs_task_execution_policy" {
  name = "ga_sb_${var.env}_ecs_task_execution_policy"
  role = aws_iam_role.ecs_task_execution_role_svc.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "GAS3Read",
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        },{
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetResourcePolicy",
                "secretsmanager:GetSecretValue",
                "secretsmanager:DescribeSecret",
                "secretsmanager:ListSecretVersionIds"
            ],
            "Resource": 
            [
              "arn:aws:secretsmanager:ap-southeast-2:288871573946:secret:caris_batch_secret-OMZKQN",
              "arn:aws:secretsmanager:${var.aws_region}:${local.account_id}:secret:TF_VAR_postgres_admin_password*",
              "arn:aws:secretsmanager:${var.aws_region}:${local.account_id}:secret:wh-infra.auto.tfvars*",
              "arn:aws:secretsmanager:${var.aws_region}:${local.account_id}:secret:geoserver_admin_password*"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "secretsmanager:GetRandomPassword",
            "Resource": "*"
        }
    ]
}
EOF
}

