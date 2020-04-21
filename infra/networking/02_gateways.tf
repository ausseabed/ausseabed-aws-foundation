# Gateway Definitions


resource "aws_internet_gateway" "ga_sb_vpc_internet_gateway" {
  vpc_id = aws_vpc.ga_sb_vpc.id

  tags = {
    Name = "ga_sb_vpc_igw"
  }
}

resource "aws_eip" "ga_sb_vpc_nat_gateway_eip" {
  vpc   = true
}

resource "aws_nat_gateway" "ga_sb_vpc_nat_gateway" {
  allocation_id = aws_eip.ga_sb_vpc_nat_gateway_eip.id
  subnet_id     = aws_subnet.ga_sb_vpc_web_subnet[0].id
}