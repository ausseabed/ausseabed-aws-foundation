variable "aws_region" {}
variable "env" {}

variable "postgres_server_spec"{}

variable "postgres_admin_password"{}

variable "networking" {
  type = object({
    vpc_id = string,
    db_tier_subnets = set(string)
  })
}

