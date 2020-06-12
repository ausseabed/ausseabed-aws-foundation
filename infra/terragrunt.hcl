locals {
  s3_backend_role_arns = map(
  "831535125571", "arn:aws:iam::007391679308:role/ga-aws-ausseabed-prod-terraform",
  "288871573946", "arn:aws:iam::007391679308:role/ga-aws-ausseabed-dev-terraform",
  )
  s3_backend_keys      = map(
  "831535125571", "env:/prod/terraform/vpc-infra/terraform-aws-foundation-vpc-infra.tfstate",
  "288871573946", "terraform/vpc-infra/terraform-aws-foundation-vpc-infra.tfstate"
  )

  envs = map(
  "831535125571", "prod",
  "288871573946", "default"
  )

  s3_backend_role_arn = local.s3_backend_role_arns[get_aws_account_id()]
  s3_backend_key      = local.s3_backend_keys[get_aws_account_id()]
  env      = local.envs[get_aws_account_id()]
}

inputs = {
  env = local.env
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
  backend = "s3"
  config  = {
    bucket   = "ausseabed-terraform-all"
    region   = "ap-southeast-2"
    key      = "${local.s3_backend_key}"
    role_arn = "${local.s3_backend_role_arn}"
  }
}

