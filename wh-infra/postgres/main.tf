data "aws_subnet" "app_tier_subnet_set" {
  for_each = var.networking.app_tier_subnets
  id       = each.value
}

resource "aws_security_group" "rds_security_group" {
  name        = "ga_sb_${var.env}_wh_db_asbwarehouse"
  description = "Used for access to the postgres database"
  vpc_id      = var.networking.vpc_id

  #HTTP
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [for s in data.aws_subnet.app_tier_subnet_set : s.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}


resource "aws_db_subnet_group" "ga_sb_wh_db_sgrp" {
  name       = "ga_sb_${var.env}_wh_db_sgrp"
  subnet_ids = var.networking.db_tier_subnets

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "asbwarehouse" {
  allocated_storage                   = 20
  enabled_cloudwatch_logs_exports     = [
    "postgresql",
    "upgrade"]
  iam_database_authentication_enabled = false
  storage_type                        = "gp2"
  engine                              = "postgres"
  engine_version                      = "11.6"
  instance_class                      = var.postgres_server_spec
  name                                = "ga_sb_${var.env}_wh_asbwarehouse_db"
  identifier                          = "ga-sb-${var.env}-wh-asbwarehouse-db"
  username                            = "postgres"
  password                            = var.postgres_admin_password
  port                                = 5432
  snapshot_identifier                 = var.snapshot_identifier
  vpc_security_group_ids              = [
    aws_security_group.rds_security_group.id
  ]

  backup_retention_period = 35
  backup_window = "12:00-14:00"

  db_subnet_group_name = aws_db_subnet_group.ga_sb_wh_db_sgrp.name
  skip_final_snapshot  = true
  // XXX So that we can easily destroy the database in terraform while we are developing
  publicly_accessible  = true

  lifecycle {
    #this prevents Terraform to destroy RDS instance when snapshot identifier is not provided.
    #to force DB rebuild with new snapshot, use `terraform taint module.postgres.aws_db_instance.asbwarehouse` first
    ignore_changes = [snapshot_identifier, name]
    # prevent_destroy = true
  }
}
