# VPC Route Table definitions

resource "aws_default_route_table" "default_route_table_private" {
  default_route_table_id = aws_vpc.ga_sb_vpc.default_route_table_id

  tags = {
    Name = "ga_sb_${var.env}_vpc_private_route"
  }
}

resource "aws_route_table" "ga_sb_vpc_public_route_table" {
  vpc_id = aws_vpc.ga_sb_vpc.id

  tags = {
    Name = "ga_sb_${var.env}_vpc_public_route"
  }
}

resource "aws_route" "internet_gateway_route" {
  route_table_id         = aws_route_table.ga_sb_vpc_public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ga_sb_vpc_internet_gateway.id
}

resource "aws_route_table" "ga_sb_vpc_nat_route_table" {
  vpc_id = aws_vpc.ga_sb_vpc.id

  tags = {
    Name = "ga_sb_${var.env}_vpc_nat_route"
  }
}

resource "aws_route" "nat_gateway_route" {
  route_table_id         = aws_route_table.ga_sb_vpc_nat_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ga_sb_vpc_nat_gateway.id
}
