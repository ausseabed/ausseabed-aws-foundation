variable "aws_region" {}

variable "az_count" {}

variable "stack_name" {
  description = "The name of our application"
  default     = "seabed"
}

variable "owner" {
  description = "A group email address to be used in tags"
  default     = "seabed@ga.gov.au"
}

variable "ga_sb_vpc_cidr" {}

variable "ga_sb_vpc_secondary_cidrs" {}

variable ga_sb_web_subnet_cidrs {}
variable ga_sb_web_subnet_segments {}

variable ga_sb_app_subnet_cidrs {}
variable ga_sb_app_subnet_segments {}

variable ga_sb_db_subnet_cidrs {}
variable ga_sb_db_subnet_segments {}

