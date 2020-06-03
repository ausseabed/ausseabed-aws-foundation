# Subnet definitions and route table associations

resource "aws_subnet" "ga_sb_vpc_web_subnet" {
  count                   = var.ga_sb_vpc_az_count
  vpc_id                  = aws_vpc.ga_sb_vpc.id
  cidr_block              = var.ga_sb_web_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "ga_sb_${var.env}_vpc_web_${count.index + 1}"
    Tier = "ga_sb_${var.env}_vpc_web",
    "kubernetes.io/role/elb" = "1",
    "kubernetes.io/cluster/ga_sb_default_eks_cluster" = "shared"


  }
  depends_on = [
    aws_vpc_ipv4_cidr_block_association.secondary_cidr
  ]
}

resource "aws_subnet" "ga_sb_vpc_app_subnet" {
  count                   = var.ga_sb_vpc_az_count
  vpc_id                  = aws_vpc.ga_sb_vpc.id
  cidr_block              = var.ga_sb_app_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "ga_sb_${var.env}_vpc_app_${count.index + 1}"
    Tier = "ga_sb_${var.env}_vpc_app",
    "kubernetes.io/role/internal-elb" = "1",
    "kubernetes.io/cluster/ga_sb_default_eks_cluster" = "shared"

  }

  depends_on = [
    aws_vpc_ipv4_cidr_block_association.secondary_cidr
  ]

}


resource "aws_subnet" "ga_sb_vpc_db_subnet" {
  count                   = var.ga_sb_vpc_az_count
  vpc_id                  = aws_vpc.ga_sb_vpc.id
  cidr_block              = var.ga_sb_db_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "ga_sb_${var.env}_vpc_db_${count.index + 1}"
    Tier = "ga_sb_${var.env}_vpc_db"
  }

  depends_on = [
    aws_vpc_ipv4_cidr_block_association.secondary_cidr
  ]
}



resource "aws_route_table_association" "ga_sb_vpc_public_assoc" {
  count          = length(aws_subnet.ga_sb_vpc_web_subnet)
  subnet_id      = aws_subnet.ga_sb_vpc_web_subnet.*.id[count.index]
  route_table_id = aws_route_table.ga_sb_vpc_public_route_table.id
}

resource "aws_route_table_association" "ga_sb_vpc_rt_app_assoc" {
  count          = length(aws_subnet.ga_sb_vpc_app_subnet)
  subnet_id      = aws_subnet.ga_sb_vpc_app_subnet.*.id[count.index]
  route_table_id = aws_route_table.ga_sb_vpc_nat_route_table.id
}

resource "aws_route_table_association" "ga_sb_vpc_rt_db_assoc" {
  count = length(aws_subnet.ga_sb_vpc_db_subnet)
  subnet_id = aws_subnet.ga_sb_vpc_db_subnet.*.id[count.index]
  route_table_id = aws_default_route_table.default_route_table_private.id
}

