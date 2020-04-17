
resource "aws_network_acl_rule" "debug_web_acl_allow_ssh" {
  network_acl_id = aws_network_acl.ga_sb_vpc_web_acl.id


  egress = false
  protocol = "tcp"
  rule_number = 20000
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = 22
  to_port = 22
}

resource "aws_network_acl_rule" "debug_web_acl_allow_egress_ssh" {
  network_acl_id = aws_network_acl.ga_sb_vpc_web_acl.id


  egress = true
  protocol = "tcp"
  rule_number = 20000
  rule_action = "allow"
  cidr_block = "10.0.0.0/8"
  from_port = 22
  to_port = 22

}

resource "aws_network_acl_rule" "debug_app_acl_allow_ssh" {
  network_acl_id = aws_network_acl.ga_sb_vpc_app_acl.id


  egress = false
  protocol = "tcp"
  rule_number = 20000
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = 22
  to_port = 22

}
resource "aws_network_acl_rule" "debug_db_acl_allow_ssh" {
  network_acl_id = aws_network_acl.ga_sb_vpc_db_acl.id


  egress = false
  protocol = "tcp"
  rule_number = 20000
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = 22
  to_port = 22

}

