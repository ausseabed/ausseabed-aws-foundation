variable "aws_region" {}

variable "env" {
  type = "string"
  default = null
}

variable "az_count" {}

variable "stack_name" {
  description = "The name of our application"
  default     = "seabed"
}

variable "owner" {
  description = "A group email address to be used in tags"
  default     = "seabed@ga.gov.au"
}

variable "backend_prod_role_arn" {
  default = "arn:aws:iam::831535125571:role/ga-aws-ausseabed-prod-terraform"
}

variable "backend_dev_role_arn" {
  default = "arn:aws:iam::007391679308:role/ga-aws-ausseabed-dev-terraform"
}

variable "ga_sb_vpc_cidr" {}

variable "ga_sb_vpc_secondary_cidrs" {}

variable ga_sb_web_subnet_cidrs {}
variable ga_sb_web_subnet_segments {}

variable ga_sb_app_subnet_cidrs {}
variable ga_sb_app_subnet_segments {}

variable ga_sb_db_subnet_cidrs {}
variable ga_sb_db_subnet_segments {}

