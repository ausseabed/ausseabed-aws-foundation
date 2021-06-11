data "aws_secretsmanager_secret" "egis_vpc_peering" {
  count = var.env == "prod" ? 1 : 0

  name = "egis_vpc_peering"
}

data "aws_secretsmanager_secret_version" "egis_vpc_peering" {
  count = var.env == "prod" ? 1 : 0

  secret_id = data.aws_secretsmanager_secret.egis_vpc_peering[count.index].id
}

resource "aws_vpc_peering_connection" "vpc_peering_connection" {
  count = var.env == "prod" ? 1 : 0

  peer_vpc_id   = jsondecode(data.aws_secretsmanager_secret_version.egis_vpc_peering[count.index].secret_string)["vpc_id"]
  vpc_id        = aws_vpc.ga_sb_vpc.id
  peer_region   = "ap-southeast-2"
  peer_owner_id = jsondecode(data.aws_secretsmanager_secret_version.egis_vpc_peering[count.index].secret_string)["account_id"]

  tags = {
    Name = "egis-vpc-peer-${var.env}"
  }
}

resource "aws_route" "egis_app_vpc_route" {
  count = var.env == "prod" ? 1 : 0

  route_table_id            = aws_route_table.ga_sb_vpc_nat_route_table.id
  destination_cidr_block    = jsondecode(data.aws_secretsmanager_secret_version.egis_vpc_peering[count.index].secret_string)["cidr_block"]
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering_connection[count.index].id
}

resource "aws_route" "egis_web_vpc_route" {
  count = var.env == "prod" ? 1 : 0

  route_table_id            = aws_route_table.ga_sb_vpc_public_route_table.id
  destination_cidr_block    = jsondecode(data.aws_secretsmanager_secret_version.egis_vpc_peering[count.index].secret_string)["cidr_block"]
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering_connection[count.index].id
}
