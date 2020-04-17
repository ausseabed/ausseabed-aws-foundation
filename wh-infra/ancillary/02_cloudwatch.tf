

resource "aws_cloudwatch_log_group" "geoserver" {
  name = "/ecs/geoserver"

  tags = {
    Environment = "poc"
    Application = "geoserver"
  }
}
resource "aws_cloudwatch_log_group" "mapserver" {
  name = "/ecs/mapserver"

  tags = {
    Environment = "poc"
    Application = "mapserver"
  }
}
