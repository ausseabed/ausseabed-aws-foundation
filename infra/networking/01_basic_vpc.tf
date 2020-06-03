#----networking/main.tf

data "aws_availability_zones" "available" {}

resource "aws_vpc" "ga_sb_vpc" {
  cidr_block           = var.ga_sb_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "ga_sb_${var.env}_vpc"
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  count = var.ga_sb_vpc_az_count - 1
  vpc_id     = aws_vpc.ga_sb_vpc.id
  cidr_block = var.ga_sb_vpc_secondary_cidrs[count.index]
}
