variable "aws_region" {}
variable "env" {}

variable "postgres_server_spec" {}

variable "postgres_admin_password" {}

variable "snapshot_identifier" {
  type    = string
  default = null
}

variable "networking" {
  type = object({
    vpc_id           = string,
    db_tier_subnets  = set(string),
    app_tier_subnets = set(string)
  })
}

