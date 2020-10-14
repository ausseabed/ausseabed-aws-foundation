#------compute/variables.tf
variable "env" {}


variable "networking" {
  type = object({
    vpc_id                                        = string,
    app_tier_subnets                              = list(string),
    web_tier_subnets                              = list(string)
  })
}
