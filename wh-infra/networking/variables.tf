variable "networking" {
  type = object({
    vpc_id = string,
    web_tier_subnets = list(string)
  })
}


variable env {}
