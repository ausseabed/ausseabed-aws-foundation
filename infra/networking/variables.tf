#------networking/variables.tf

variable "ga_sb_vpc_cidr" {}

variable "ga_sb_vpc_az_count" {}



variable "ga_sb_vpc_secondary_cidrs" {
  type = list(string)
}

variable "ga_sb_web_subnet_cidrs" {
  type = list(string)
}

variable "ga_sb_app_subnet_cidrs" {
  type = list(string)
}

variable "ga_sb_db_subnet_cidrs" {
  type = list(string)
}
