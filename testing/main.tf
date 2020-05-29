provider "aws" {
  region  = var.aws_region
  version = "2.54"
}

resource "random_string" "build_id" {
  count = var.enabled ? 1 : 0

  length  = 16
  upper   = false
  special = false
}

locals {
//  test = random_string.build_id[0].result
}

data "aws_iam_role" "getResumeFromStep_role" {
  name = "getResumeFromStep-lambda-role"
}

module "get_resume_lambda_function" {
  source = "git@github.com:ausseabed/terraform-aws-lambda-builder.git"

  # Standard aws_lambda_function attributes.
  function_name = "getResumeFromStep"
  handler       = "getResumeFromStep.lambda_handler"
  runtime       = "python3.6"
  timeout       = 30
  role          = data.aws_iam_role.getResumeFromStep_role.arn
  enabled       = true

  # Enable build functionality.
  build_mode = "FILENAME"
  source_dir = "${path.module}/src/lambda/resume_from_step"
  filename   = "getResumeFromStep.py"

  # Create and use a role with CloudWatch Logs permissions.
  role_cloudwatch_logs = true
}

