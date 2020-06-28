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


data "aws_lb_target_group" "ga_sb_pc_load_balancer_outside" {
  name        = "ga-sb-${var.env}-pc-lb-outside"
}


data "aws_security_group" "ga_sb_env_pc_public_sg" {
  name        = "ga_sb_${var.env}_pc_public_sg"
}
