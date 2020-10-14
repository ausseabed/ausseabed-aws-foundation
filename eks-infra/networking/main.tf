data "aws_availability_zones" "available" {}

data "aws_vpc" "ga_sb_vpc" {
  tags = {
    Name = "ga_sb_${var.env}_vpc"
  }
}

data "aws_subnet_ids" "web_tier_subnets" {
  vpc_id = data.aws_vpc.ga_sb_vpc.id
  filter {
    name = "tag:Tier"
    values = [
      "ga_sb_${var.env}_vpc_web"
    ]
  }
}

data "aws_subnet_ids" "app_tier_subnets" {
  vpc_id = data.aws_vpc.ga_sb_vpc.id
  filter {
    name = "tag:Tier"
    values = [
      "ga_sb_${var.env}_vpc_app"
    ]
  }
}

data "aws_subnet_ids" "db_tier_subnets" {
  vpc_id = data.aws_vpc.ga_sb_vpc.id
  filter {
    name = "tag:Tier"
    values = [
      "ga_sb_${var.env}_vpc_db"
    ]
  }
}

