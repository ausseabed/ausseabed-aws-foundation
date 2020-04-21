resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.ga_sb_vpc.default_network_acl_id
  tags = {
    Name = "ga_sb_vpc_default_acl_deny_all"
  }

  # as a default Network ACL, if subnet is not associated to anything else,
  # it will get associated to this one.
  # no rules defined on purpose, this will deny all traffic in and out of all associated subnets
}

#-- Web-tier NACL Rules

resource "aws_network_acl" "ga_sb_vpc_web_acl" {
  vpc_id = aws_vpc.ga_sb_vpc.id

  tags = {
    Name = "ga_sb_vpc_web_acl"
  }

  subnet_ids = aws_subnet.ga_sb_vpc_web_subnet.*.id

}

resource "aws_network_acl_rule" "web_acl_expose_http_port_to_the_world" {
  network_acl_id = aws_network_acl.ga_sb_vpc_web_acl.id


  egress = false
  protocol = "tcp"
  rule_number = 100
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = 80
  to_port = 80

}

resource "aws_network_acl_rule" "web_acl_expose_https_port_to_the_world" {
  network_acl_id = aws_network_acl.ga_sb_vpc_web_acl.id
  egress = false
  protocol = "tcp"
  rule_number = 200
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = 443
  to_port = 443

}

resource "aws_network_acl_rule" "web_acl_expose_ethemeral_port_to_vpc" {
  network_acl_id = aws_network_acl.ga_sb_vpc_web_acl.id

  egress = false
  protocol = "tcp"
  rule_number = 10000
  rule_action = "allow"
  cidr_block = aws_vpc.ga_sb_vpc.cidr_block
  from_port = 32768
  to_port = 60999

}

resource "aws_network_acl_rule" "web_acl_expose_ethemeral_port_to_vpc_additional_cidrs" {
  network_acl_id = aws_network_acl.ga_sb_vpc_web_acl.id

  count = length(aws_vpc_ipv4_cidr_block_association.secondary_cidr)

  egress = false
  protocol = "tcp"
  rule_number = 10001 + count.index
  rule_action = "allow"
  cidr_block = aws_vpc_ipv4_cidr_block_association.secondary_cidr[count.index].cidr_block
  from_port = 32768
  to_port = 60999

}

resource "aws_network_acl_rule" "web_acl_enable_all_ingress_between_azs" {
  network_acl_id = aws_network_acl.ga_sb_vpc_web_acl.id

  count = length(var.ga_sb_web_subnet_segments)

  egress = false
  protocol = "tcp"
  rule_number = 10100 + count.index
  rule_action = "allow"
  cidr_block = var.ga_sb_web_subnet_segments[count.index]
  from_port = 0
  to_port = 65535

}



resource "aws_network_acl_rule" "web_acl_enable_all_egress_between_azs" {
  network_acl_id = aws_network_acl.ga_sb_vpc_web_acl.id

  count = length(var.ga_sb_web_subnet_segments)

  egress = true
  protocol = "tcp"
  rule_number = 10100 + count.index
  rule_action = "allow"
  cidr_block = var.ga_sb_web_subnet_segments[count.index]
  from_port = 0
  to_port = 65535

}

resource "aws_network_acl_rule" "web_acl_enable_all_egress_to_app_tier" {
  network_acl_id = aws_network_acl.ga_sb_vpc_web_acl.id

  count = length(var.ga_sb_app_subnet_segments)

  egress = true
  protocol = "tcp"
  rule_number = 10200 + count.index
  rule_action = "allow"
  cidr_block = var.ga_sb_app_subnet_segments[count.index]
  from_port = 0
  to_port = 65535

}

resource "aws_network_acl_rule" "web_acl_expose_egress_ethemeral_port_to_the_world" {
  network_acl_id = aws_network_acl.ga_sb_vpc_web_acl.id

  egress = true
  protocol = "tcp"
  rule_number = 10000
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = 32768
  to_port = 60999

}


#-- APP-tier NACL Rules


resource "aws_network_acl" "ga_sb_vpc_app_acl" {
  vpc_id = aws_vpc.ga_sb_vpc.id

  tags = {
    Name = "ga_sb_vpc_app_acl"
  }

  subnet_ids = aws_subnet.ga_sb_vpc_app_subnet.*.id

}

resource "aws_network_acl_rule" "app_acl_expose_http_port_to_web_subnets" {
  network_acl_id = aws_network_acl.ga_sb_vpc_app_acl.id

  count = length(aws_subnet.ga_sb_vpc_web_subnet)

  egress = false
  protocol = "tcp"
  rule_number = 100 + count.index
  rule_action = "allow"
  cidr_block = aws_subnet.ga_sb_vpc_web_subnet[count.index].cidr_block
  from_port = 80
  to_port = 80

}

resource "aws_network_acl_rule" "app_acl_expose_https_port_to_web_subnets" {
  network_acl_id = aws_network_acl.ga_sb_vpc_app_acl.id

  count = length(aws_subnet.ga_sb_vpc_web_subnet)

  egress = false
  protocol = "tcp"
  rule_number = 200 + count.index
  rule_action = "allow"
  cidr_block = aws_subnet.ga_sb_vpc_web_subnet[count.index].cidr_block
  from_port = 443
  to_port = 443

}


resource "aws_network_acl_rule" "app_acl_expose_ethemeral_port_to_vpc" {
  network_acl_id = aws_network_acl.ga_sb_vpc_app_acl.id

  egress = false
  protocol = "tcp"
  rule_number = 10000
  rule_action = "allow"
  cidr_block = aws_vpc.ga_sb_vpc.cidr_block
  from_port = 32768
  to_port = 60999

}

resource "aws_network_acl_rule" "app_acl_expose_ethemeral_port_to_vpc_additional_cidrs" {
  network_acl_id = aws_network_acl.ga_sb_vpc_app_acl.id

  count = length(aws_vpc_ipv4_cidr_block_association.secondary_cidr)

  egress = false
  protocol = "tcp"
  rule_number = 10001 + count.index
  rule_action = "allow"
  cidr_block = aws_vpc_ipv4_cidr_block_association.secondary_cidr[count.index].cidr_block
  from_port = 32768
  to_port = 60999

}


resource "aws_network_acl_rule" "app_acl_enable_all_ingress_between_azs" {
  network_acl_id = aws_network_acl.ga_sb_vpc_app_acl.id

  count = length(aws_subnet.ga_sb_vpc_app_subnet)

  egress = false
  protocol = "tcp"
  rule_number = 10100 + count.index
  rule_action = "allow"
  cidr_block = aws_subnet.ga_sb_vpc_app_subnet[count.index].cidr_block
  from_port = 0
  to_port = 65535

}

resource "aws_network_acl_rule" "app_acl_enable_all_egress_between_azs" {
  network_acl_id = aws_network_acl.ga_sb_vpc_app_acl.id

  count = length(aws_subnet.ga_sb_vpc_app_subnet)

  egress = true
  protocol = "tcp"
  rule_number = 10100 + count.index
  rule_action = "allow"
  cidr_block = aws_subnet.ga_sb_vpc_app_subnet[count.index].cidr_block
  from_port = 0
  to_port = 65535

}

resource "aws_network_acl_rule" "app_acl_expose_egress_ethemeral_port_to_web_subnets" {
  network_acl_id = aws_network_acl.ga_sb_vpc_app_acl.id

  count = length(aws_subnet.ga_sb_vpc_web_subnet)

  egress = true
  protocol = "tcp"
  rule_number = 10000 + count.index
  rule_action = "allow"
  cidr_block = aws_subnet.ga_sb_vpc_web_subnet[count.index].cidr_block
  from_port = 1024
  to_port = 65535

}

resource "aws_network_acl_rule" "app_acl_allow_https_port_to_web_subnets" {
  network_acl_id = aws_network_acl.ga_sb_vpc_app_acl.id

  count = length(aws_subnet.ga_sb_vpc_web_subnet)

  egress = true
  protocol = "tcp"
  rule_number = 10200 + count.index
  rule_action = "allow"
  cidr_block = aws_subnet.ga_sb_vpc_web_subnet[count.index].cidr_block
  from_port = 443
  to_port = 443

}

resource "aws_network_acl_rule" "app_acl_enable_all_egress_to_db_tier" {
  network_acl_id = aws_network_acl.ga_sb_vpc_app_acl.id

  count = length(aws_subnet.ga_sb_vpc_db_subnet)

  egress = true
  protocol = "tcp"
  rule_number = 10300 + count.index
  rule_action = "allow"
  cidr_block = aws_subnet.ga_sb_vpc_db_subnet[count.index].cidr_block
  from_port = 0
  to_port = 65535

}


#-- DB-tier NACL Rules

resource "aws_network_acl" "ga_sb_vpc_db_acl" {
  vpc_id = aws_vpc.ga_sb_vpc.id

  tags = {
    Name = "ga_sb_vpc_db_acl"
  }

  subnet_ids = aws_subnet.ga_sb_vpc_db_subnet.*.id

}

resource "aws_network_acl_rule" "db_acl_expose_postgresql_port_to_app_subnets" {
  network_acl_id = aws_network_acl.ga_sb_vpc_db_acl.id

  count = length(aws_subnet.ga_sb_vpc_db_subnet)

  egress = false
  protocol = "tcp"
  rule_number = 100 + count.index
  rule_action = "allow"
  cidr_block = aws_subnet.ga_sb_vpc_app_subnet[count.index].cidr_block
  from_port = 5432
  to_port = 5432

}

resource "aws_network_acl_rule" "db_acl_expose_egress_ephemeral_to_app_subnet" {
  network_acl_id = aws_network_acl.ga_sb_vpc_db_acl.id
  count = length(aws_subnet.ga_sb_vpc_db_subnet)

  egress = true
  protocol = "tcp"
  rule_number = 10000 + count.index
  rule_action = "allow"
  cidr_block = aws_subnet.ga_sb_vpc_app_subnet[count.index].cidr_block
  from_port = 1024
  to_port = 65535

}