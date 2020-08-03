locals {
  s3_backend_role_arns = map(
  "831535125571", "arn:aws:iam::007391679308:role/ga-aws-ausseabed-prod-terraform",
  "288871573946", "arn:aws:iam::007391679308:role/ga-aws-ausseabed-dev-terraform",
  )
  s3_backend_keys      = map(
  "831535125571", "env:/prod/terraform/pcat-app-deployment/terraform-aws-foundation-pcat-app-deployment.tfstate",
  "288871573946", "terraform/pcat-app-deployment/terraform-aws-foundation-pcat-app-deployment.tfstate"
  )

  envs = map(
  "831535125571", "prod",
  "288871573946", "default"
  )

  pcat_client_images = map(
  "831535125571", "007391679308.dkr.ecr.ap-southeast-2.amazonaws.com/ausseabed-product-catalogue-client:0.0.9",
  "288871573946", "288871573946.dkr.ecr.ap-southeast-2.amazonaws.com/ausseabed-product-catalogue-client:latest"
  )

  pcat_server_images = map(
  "831535125571", "007391679308.dkr.ecr.ap-southeast-2.amazonaws.com/ausseabed-product-catalogue-server:0.0.9",
  "288871573946", "288871573946.dkr.ecr.ap-southeast-2.amazonaws.com/ausseabed-product-catalogue-server:latest"
  )

  s3_backend_role_arn = local.s3_backend_role_arns[get_aws_account_id()]
  s3_backend_key      = local.s3_backend_keys[get_aws_account_id()]
  env                 = local.envs[get_aws_account_id()]
  pcat_client_image   = local.pcat_client_images[get_aws_account_id()]
  pcat_server_image   = local.pcat_server_images[get_aws_account_id()]
}

inputs = {
  env          = local.env
  server_image = local.pcat_server_image
  client_image = local.pcat_client_image
}

terraform {


  before_hook "before_hook" {
    commands = [
      "apply",
      "plan"]
    execute  = [
      "echo",
      "Using S3 backend key `${local.s3_backend_key}` using assumed role: `${local.s3_backend_role_arn}`"]
  }
}


remote_state {
  backend  = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }

  config = {
    bucket   = "ausseabed-terraform-all"
    region   = "ap-southeast-2"
    key      = "${local.s3_backend_key}"
    role_arn = "${local.s3_backend_role_arn}"
  }
}

