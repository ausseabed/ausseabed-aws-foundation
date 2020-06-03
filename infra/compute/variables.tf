#------networking/variables.tf

variable "env" {}


variable "security" {
  type = object({
    eks_role_arn = string,
    eks_fargate_profile_arn = string
  })
}

variable "networking" {
  type = object({
    vpc_id = string,
    app_tier_subnets = list(string),
    web_tier_subnets = list(string)
  })
}
