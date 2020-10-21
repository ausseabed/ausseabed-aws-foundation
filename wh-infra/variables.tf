
variable "aws_region" {}

variable "env" {
  type    = string
  default = null
}

#------ storage variables



#-------networking variables

variable "vpc_cidr" {}

variable "public_cidrs" {
  type = list(string)
}

variable "accessip" {}

variable "postgres_server_spec" {}
variable "postgres_snapshot_id" {
  type    = string
  default = null
}
