# VPC Route Table definitions

resource "aws_default_route_table" "default_route_table_private" {
  default_route_table_id = aws_vpc.ga_sb_vpc.default_route_table_id

  tags = {
    Name = "ga_sb_vpc_private_route"
  }
}

resource "aws_route_table" "ga_sb_vpc_public_route_table" {
  vpc_id = aws_vpc.ga_sb_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ga_sb_vpc_internet_gateway.id
  }

  tags = {
    Name = "ga_sb_vpc_public_route"
  }
}

resource "aws_route_table" "ga_sb_vpc_nat_route_table" {
  vpc_id = aws_vpc.ga_sb_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ga_sb_vpc_nat_gateway.id
  }

  tags = {
    Name = "ga_sb_vpc_nat_route"
  }
}

