data "aws_ami" "amazon_linux" {
  most_recent = true
  name_regex  = "amzn2-ami-hvm-.*-ebs"
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

data "aws_subnet" "web_tier_subnet" {
  filter {
    name   = "tag:Name"
    values = ["ga_sb_vpc_web_1"]
  }
}

data "aws_subnet" "app_tier_subnet" {
  filter {
    name   = "tag:Name"
    values = ["ga_sb_vpc_app_1"]
  }
}
data "aws_subnet" "db_tier_subnet" {
  filter {
    name   = "tag:Name"
    values = ["ga_sb_vpc_db_1"]
  }
}

# resource "aws_instance" "web_tier_instance" {
#   ami           = data.aws_ami.amazon_linux.id
#   instance_type = "t2.micro"
#   subnet_id = data.aws_subnet.web_tier_subnet.id
#   key_name = "dave-personal"
#   iam_instance_profile = "Manual-SSM-Managed-Instance"
#   tags = {
#     Name = "web_tier_test_instance"
#   }
# }

resource "aws_instance" "app_tier_instance" {
  ami                  = data.aws_ami.amazon_linux.id
  instance_type        = "t2.micro"
  subnet_id            = data.aws_subnet.app_tier_subnet.id
  key_name             = "AWS-dev-box"
  iam_instance_profile = "for_dave_cli"
  tags = {
    Name = "app_tier_dave_test_instance"
  }
  root_block_device {
    volume_type = "gp2"
    volume_size = 30
  }
  lifecycle {
    prevent_destroy = true
  }
}

# resource "aws_instance" "db_tier_instance" {
#   ami           = data.aws_ami.amazon_linux.id
#   instance_type = "t2.micro"
#   subnet_id = data.aws_subnet.db_tier_subnet.id
#   key_name = "dave-personal"
#   iam_instance_profile = "Manual-SSM-Managed-Instance"
#   tags = {
#     Name = "db_tier_test_instance"
#   }
# }
