data "aws_ami" "amazon_linux" {
  most_recent      = true
  name_regex = "amzn-ami-hvm-.*-ebs"
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*"]
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


resource "aws_instance" "web_tier_instance" {
  count = local.enable_ec2_test ? 1 : 0
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  subnet_id = data.aws_subnet.web_tier_subnet.id
  key_name = "egor-personal"
  iam_instance_profile = "Manual-SSM-Managed-Instance"
  tags = {
    Name = "web_tier_test_instance"
  }
}

resource "aws_instance" "app_tier_instance" {
  count = local.enable_ec2_test ? 1 : 0

  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  subnet_id = data.aws_subnet.app_tier_subnet.id
  key_name = "egor-personal"
  iam_instance_profile = "Manual-SSM-Managed-Instance"
  tags = {
    Name = "app_tier_test_instance"
  }
}

resource "aws_instance" "db_tier_instance" {
  count = local.enable_ec2_test ? 1 : 0

  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  subnet_id = data.aws_subnet.db_tier_subnet.id
  key_name = "egor-personal"
  iam_instance_profile = "Manual-SSM-Managed-Instance"
  tags = {
    Name = "db_tier_test_instance"
  }
}
