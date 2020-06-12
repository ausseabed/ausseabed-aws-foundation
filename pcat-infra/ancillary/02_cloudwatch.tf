

resource "aws_cloudwatch_log_group" "product_catalogue" {
  name = "/ecs/ga_sb_${var.env}_product_catalogue"

  tags = {
    Environment = "poc"
    Application = "product_catalogue"
  }
}
