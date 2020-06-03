#-----networking/outputs.tf

output "vpc_id" {
  value = aws_vpc.ga_sb_vpc.id
}

output "public_subnets" {
  value = aws_subnet.ga_sb_vpc_app_subnet.*.id
}

output "private_subnets" {
  value = aws_subnet.ga_sb_vpc_app_subnet.*.id
}

output "app_tier_subnets" {
  value = aws_subnet.ga_sb_vpc_app_subnet.*.id
}
output "web_tier_subnets" {
  value = aws_subnet.ga_sb_vpc_web_subnet.*.id
}
