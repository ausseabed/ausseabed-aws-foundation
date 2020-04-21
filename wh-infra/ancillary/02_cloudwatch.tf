

resource "aws_cloudwatch_log_group" "geoserver" {
  name = "/ecs/ga_sb_${var.env}_geoserver"

  tags = {
    Environment = "poc"
    Application = "geoserver"
  }
}
resource "aws_cloudwatch_log_group" "mapserver" {
  name = "/ecs/ga_sb_${var.env}_mapserver"

  tags = {
    Environment = "poc"
    Application = "mapserver"
  }
}
