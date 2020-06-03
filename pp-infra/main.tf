locals {
  env = terraform.workspace
}

provider "aws" {
  region  = var.aws_region
  version = "2.54"
}

terraform {
  backend "s3" {
    bucket = "ausseabed-aws-foundation-tf-infra"
    key    = "terraform/terraform-aws-foundation-pp-infra.tfstate"
    region = "ap-southeast-2"
  }
}

module "ancillary" {
  source = "./ancillary"
  env    = local.env
  region = var.aws_region
}

module "networking" {
  source = "./networking"
  env                         = local.env

}


module "compute" {
  source = "./compute"

  env                         = local.env
  fargate_cpu                 = var.fargate_cpu
  fargate_memory              = var.fargate_memory
  caris_caller_image          = var.caris_caller_image
  startstopec2_image          = var.startstopec2_image
  gdal_image                  = var.gdal_image
  mbsystem_image              = var.mbsystem_image
  pdal_image                  = var.pdal_image
  ecs_task_execution_role_arn = module.ancillary.ecs_task_execution_role_arn
}


module "pipelines" {
  source                               = "./pipelines"
  env                                  = local.env
  networking                           = module.networking
  ausseabed_sm_role                    = module.ancillary.ga_sb_pp_sfn_role
  aws_ecs_cluster_arn                  = module.compute.aws_ecs_cluster_arn
  aws_ecs_task_definition_gdal_arn     = module.compute.aws_ecs_task_definition_gdal_arn
  aws_ecs_task_definition_mbsystem_arn = module.compute.aws_ecs_task_definition_mbsystem_arn
  aws_ecs_task_definition_pdal_arn     = module.compute.aws_ecs_task_definition_pdal_arn

  aws_ecs_task_definition_caris_version_arn = module.compute.aws_ecs_task_definition_caris-version_arn
  aws_ecs_task_definition_startstopec2_arn  = module.compute.aws_ecs_task_definition_startstopec2_arn
  local_storage_folder                      = var.local_storage_folder
}


module "get_resume_lambda_function" {
  source = "git@github.com:ausseabed/terraform-aws-lambda-builder.git"

  # Standard aws_lambda_function attributes.
  function_name = "ga_sb_${local.env}-getResumeFromStep"
  handler       = "getResumeFromStep.lambda_handler"
  runtime       = "python3.6"
  timeout       = 30
  role          = module.ancillary.getResumeFromStep_role
  create_role   = true
  enabled       = true

  # Enable build functionality.
  build_mode = "FILENAME"
  source_dir = "${path.module}/src/lambda/resume_from_step"
  filename   = "getResumeFromStep.py"

  # Create and use a role with CloudWatch Logs permissions.
  role_cloudwatch_logs = true
}


module "identify_instrument_lambda_function" {
  source = "github.com/ausseabed/terraform-aws-lambda-builder"

  # Standard aws_lambda_function attributes.
  function_name = "ga_sb_${local.env}-identify_instrument_files"
  handler       = "identify_instrument_files.lambda_handler"
  runtime       = "python3.6"
  timeout       = 300
  role          = module.ancillary.identify_instrument_files_role
  create_role   = true
  enabled       = true

  # Enable build functionality.
  build_mode = "FILENAME"
  source_dir = "${path.module}/src/lambda/identify_instrument_files"
  filename   = "identify_instrument_files.py"

  # Create and use a role with CloudWatch Logs permissions.
  role_cloudwatch_logs = true
}


#carisbatch  --run FilterProcessedDepths   --filter-type SURFACE --surface ${var.local_storage_folder}\\GA-0364_BlueFin_MB\\BlueFin_2018-172_1m.csar --threshold-type STANDARD_DEVIATION --scalar 1.6 file:///${var.local_storage_folder}\\GA-0364_BlueFin_MB\\GA-0364_BlueFin_MB.hips