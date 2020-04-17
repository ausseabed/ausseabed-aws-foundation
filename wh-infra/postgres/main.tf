resource "aws_security_group" "rds_security_group" {
  name = "ga_sb_wh_db_asbwarehouse"
  description = "Used for access to the postgres database"
  vpc_id = var.networking.vpc_id

  #HTTP
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    #cidr_blocks = [var.accessip]
    cidr_blocks = [
      "52.62.76.203/32"
    ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}


resource "aws_db_subnet_group" "ga_sb_wh_db_sgrp" {
  name = "ga_sb_wh_db_sgrp"
  subnet_ids = var.networking.db_tier_subnets

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "asbwarehouse" {
  allocated_storage = 20
  enabled_cloudwatch_logs_exports = [
    "postgresql",
    "upgrade"]
  iam_database_authentication_enabled = false
  storage_type = "gp2"
  engine = "postgres"
  engine_version = "11.6"
  instance_class = var.postgres_server_spec
  name = "ga_sb_wh_asbwarehouse_db"
  identifier = "ga_sb_wh_asbwarehouse_db"
  username = "postgres"
  password = var.postgres_admin_password
  //parameter_group_name = "default.mysql5.7"
  port = 5432
  vpc_security_group_ids = [
    aws_security_group.rds_security_group.id
  ]

  db_subnet_group_name = aws_db_subnet_group.ga_sb_wh_db_sgrp.name
  skip_final_snapshot = true
  // XXX So that we can easily destroy the database in terraform while we are developing
  publicly_accessible = true
}