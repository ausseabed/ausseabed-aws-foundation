#-----networking/outputs.tf

output "public_subnets" {
  value = aws_subnet.ga_sb_vpc_app_subnet.*.id
}

output "private_subnets" {
  value = aws_subnet.ga_sb_vpc_app_subnet.*.id
}
