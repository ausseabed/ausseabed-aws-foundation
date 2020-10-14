provider "aws" {
  region = var.aws_region
}

locals {
  enable_ec2_test = false
  env             = "default"
}

module "networking" {
  source = "./networking"
  env    = local.env

}

module "postgres" {
  source               = "./postgres"
  env                  = local.env
  aws_region           = var.aws_region
  postgres_server_spec = "db.t2.micro"
  snapshot_identifier  = null
  networking           = module.networking

  postgres_admin_password = "password12345"
}

resource "aws_cognito_user_pool" "pool" {
  name = "ga_sb_${local.env}_spt_cognito_pool"
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = "spt-dev"
  user_pool_id = aws_cognito_user_pool.pool.id
}

resource "aws_cognito_user_pool_client" "client" {
  name = "ga_sb_${local.env}_spt_cognito_client"

  user_pool_id = aws_cognito_user_pool.pool.id

  supported_identity_providers         = [
    "COGNITO"]
  generate_secret                      = true
  explicit_auth_flows                  = [
    "ALLOW_ADMIN_USER_PASSWORD_AUTH",
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"]

  allowed_oauth_flows                  = [
    "code",
    "implicit",
  ]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = [
    "email",
    "openid",
    "profile",
  ]
  callback_urls                        = [
    "https://${aws_acm_certificate.spt_cert.domain_name}/auth/callback"]
  logout_urls                          = [
    "https://${aws_acm_certificate.spt_cert.domain_name}/"]
}

