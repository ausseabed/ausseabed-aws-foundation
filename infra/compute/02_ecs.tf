resource "aws_ecs_cluster" "ga_sb_ecs_cluster" {
  name = "ga_sb_${var.env}_ecs_cluster"
  tags = {
    Name = "ga_sb_${var.env}_ecs_cluster"
  }
}

