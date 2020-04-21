//# VPC Endpoints
//
//resource "aws_security_group" "ga_sb_vpc_sg_ssm_endpoint" {
//  name = "ga_sb_vpc_sg_ssm_endpoint"
//  description = "Allow HTTPS to SSM endpoint"
//  vpc_id = aws_vpc.ga_sb_vpc.id
//
//  ingress {
//    description = "HTTPS from VPC"
//    from_port = 443
//    to_port = 443
//    protocol = "tcp"
//    cidr_blocks = concat(
//    [
//      aws_vpc.ga_sb_vpc.cidr_block
//    ],
//    aws_vpc_ipv4_cidr_block_association.secondary_cidr.*.cidr_block
//    )
//
//  }
//
//  egress {
//    from_port = 0
//    to_port = 0
//    protocol = "-1"
//    cidr_blocks = [
//      "0.0.0.0/0"]
//  }
//
//  tags = {
//    Name = "ga_sb_vpc_sg_ssm_endpoint"
//  }
//}
//
//resource "aws_vpc_endpoint" "ssm" {
//  vpc_id = aws_vpc.ga_sb_vpc.id
//  service_name = "com.amazonaws.ap-southeast-2.ssm"
//  vpc_endpoint_type = "Interface"
//  private_dns_enabled = true
//  subnet_ids = aws_subnet.ga_sb_vpc_web_subnet.*.id
//
//  security_group_ids = [
//    aws_security_group.ga_sb_vpc_sg_ssm_endpoint.id
//  ]
//
//}
//
//resource "aws_vpc_endpoint" "ssmmessages" {
//  vpc_id = aws_vpc.ga_sb_vpc.id
//  service_name = "com.amazonaws.ap-southeast-2.ssmmessages"
//  vpc_endpoint_type = "Interface"
//  private_dns_enabled = true
//  subnet_ids = aws_subnet.ga_sb_vpc_web_subnet.*.id
//
//  security_group_ids = [
//    aws_security_group.ga_sb_vpc_sg_ssm_endpoint.id
//  ]
//
//}
//
//resource "aws_vpc_endpoint" "ec2messages" {
//  vpc_id = aws_vpc.ga_sb_vpc.id
//  service_name = "com.amazonaws.ap-southeast-2.ec2messages"
//  vpc_endpoint_type = "Interface"
//  private_dns_enabled = true
//  subnet_ids = aws_subnet.ga_sb_vpc_web_subnet.*.id
//
//  security_group_ids = [
//    aws_security_group.ga_sb_vpc_sg_ssm_endpoint.id
//  ]
//
//}
//
//
