data "aws_availability_zones" "available" {}

data "aws_vpc" "ga_sb_vpc" {
  tags = {
    Name = "ga_sb_vpc"
  }
}

data "aws_subnet" "web_tier_subnet" {
  filter {
    name = "tag:Name"
    values = [
      "ga_sb_vpc_web_1"
    ]
  }
}

data "aws_subnet_ids" "app_tier_subnets" {
  vpc_id = data.aws_vpc.ga_sb_vpc.id
  filter {
    name = "tag:Tier"
    values = [
      "ga_sb_vpc_app"
    ]
  }
}

data "aws_subnet_ids" "db_tier_subnets" {
  vpc_id = data.aws_vpc.ga_sb_vpc.id
  filter {
    name = "tag:Tier"
    values = [
      "ga_sb_vpc_db"
    ]
  }
}
