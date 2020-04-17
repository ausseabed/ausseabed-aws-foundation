#-----networking/outputs.tf

output "db_tier_subnets" {
  value = data.aws_subnet_ids.db_tier_subnets.ids
}

output "app_tier_subnets" {
  value = data.aws_subnet_ids.app_tier_subnets.ids
}

output "vpc_id" {
  value = data.aws_vpc.ga_sb_vpc.id
}

output "vpc_arn" {
  value = data.aws_vpc.ga_sb_vpc.arn
}
