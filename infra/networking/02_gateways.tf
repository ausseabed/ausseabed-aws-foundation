# Gateway Definitions


resource "aws_internet_gateway" "ga_sb_vpc_internet_gateway" {
  vpc_id = aws_vpc.ga_sb_vpc.id

  tags = {
    Name = "ga_sb_vpc_igw"
  }
}

